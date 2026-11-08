// Gemeinsamer Datenspeicher. Mit Supabase-Konfiguration werden alle Änderungen live
// zwischen den Handys synchronisiert, ohne läuft alles lokal im Browser.
//
// Alle Daten liegen als Einträge (collection, id, data) vor:
//   settings/main, meta/plan, plan/0..6, votes/<woche>:<rezept>,
//   history/<woche>:<rezept>, shopping/<id>

const CACHE_KEY = 'weekleat:data'
const QUEUE_KEY = 'weekleat:queue'

function readJson(key, fallback) {
  try {
    const v = localStorage.getItem(key)
    return v ? JSON.parse(v) : fallback
  } catch {
    return fallback
  }
}
function writeJson(key, value) {
  try {
    localStorage.setItem(key, JSON.stringify(value))
  } catch {
    /* Speicher voll oder gesperrt – egal, nur Cache */
  }
}

export const supabaseConfig = {
  url: import.meta.env.VITE_SUPABASE_URL || '',
  key: import.meta.env.VITE_SUPABASE_ANON_KEY || import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY || '',
}
export const syncEnabled = !!(supabaseConfig.url && supabaseConfig.key)

class Store {
  constructor() {
    this.data = readJson(CACHE_KEY, {})
    this.queue = readJson(QUEUE_KEY, [])
    this.listeners = new Set()
    this.status = syncEnabled ? 'connecting' : 'local' // local | connecting | online | offline | error
    this.session = null
    this.client = null
    this.channel = null
    this.flushing = false
  }

  // ---- Lesen ----
  all(collection) {
    return Object.entries(this.data[collection] || {}).map(([id, v]) => ({ id, ...v }))
  }
  get(collection, id) {
    const v = this.data[collection]?.[id]
    return v ? { id, ...v } : null
  }

  subscribe(fn) {
    this.listeners.add(fn)
    return () => this.listeners.delete(fn)
  }
  emit() {
    writeJson(CACHE_KEY, this.data)
    for (const fn of this.listeners) fn()
  }
  setStatus(s) {
    this.status = s
    for (const fn of this.listeners) fn()
  }

  // ---- Schreiben (sofort lokal, dann Server) ----
  apply(op) {
    const col = (this.data[op.collection] ||= {})
    if (op.type === 'put') for (const row of op.rows) {
      const { id, ...rest } = row
      col[id] = rest
    }
    else for (const id of op.ids) delete col[id]
  }

  write(ops) {
    if (!ops.length) return
    for (const op of ops) this.apply(op)
    this.emit()
    if (syncEnabled) {
      this.queue.push(...ops)
      writeJson(QUEUE_KEY, this.queue)
      this.flush()
    }
  }

  put(collection, rows) {
    rows = Array.isArray(rows) ? rows : [rows]
    if (rows.length) this.write([{ type: 'put', collection, rows }])
  }
  remove(collection, ids) {
    ids = Array.isArray(ids) ? ids : [ids]
    if (ids.length) this.write([{ type: 'del', collection, ids }])
  }
  /** mehrere Änderungen auf einmal */
  batch(ops) {
    this.write(ops.filter((o) => (o.rows || o.ids).length))
  }

  // ---- Supabase ----
  async init() {
    if (!syncEnabled) {
      window.addEventListener('storage', (e) => {
        if (e.key === CACHE_KEY) {
          this.data = readJson(CACHE_KEY, {})
          for (const fn of this.listeners) fn()
        }
      })
      return
    }
    const { createClient } = await import('@supabase/supabase-js')
    this.client = createClient(supabaseConfig.url, supabaseConfig.key, {
      auth: { persistSession: true, autoRefreshToken: true, storageKey: 'weekleat:auth' },
    })
    const { data } = await this.client.auth.getSession()
    this.session = data.session
    this.client.auth.onAuthStateChange((_event, session) => {
      const was = !!this.session
      this.session = session
      if (!was && session) this.connect()
      for (const fn of this.listeners) fn()
    })
    if (this.session) await this.connect()
    else this.setStatus('offline')

    window.addEventListener('online', () => this.refresh())
    document.addEventListener('visibilitychange', () => {
      if (document.visibilityState === 'visible') this.refresh()
    })
  }

  async signIn(email, password) {
    const { error } = await this.client.auth.signInWithPassword({ email, password })
    if (error) throw error
  }
  async signOut() {
    await this.client.auth.signOut()
    this.channel?.unsubscribe()
    this.channel = null
    this.setStatus('offline')
  }

  async connect() {
    if (!this.channel) {
      this.channel = this.client
        .channel('items')
        .on('postgres_changes', { event: '*', schema: 'public', table: 'items' }, (p) => {
          if (p.eventType === 'DELETE') {
            const { collection, id } = p.old
            if (this.data[collection]) delete this.data[collection][id]
          } else {
            const { collection, id, data } = p.new
            ;(this.data[collection] ||= {})[id] = data
          }
          this.emit()
        })
        .subscribe((s) => {
          if (s === 'SUBSCRIBED') this.refresh()
          else if (s === 'CHANNEL_ERROR' || s === 'TIMED_OUT') this.setStatus('offline')
        })
    }
    await this.refresh()
  }

  /** Kompletten Stand vom Server holen und noch nicht gesendete eigene Änderungen darüber legen. */
  async refresh() {
    if (!this.client || !this.session) return
    await this.flush()
    const rows = []
    const pageSize = 1000
    for (let from = 0; ; from += pageSize) {
      const { data, error } = await this.client
        .from('items')
        .select('collection,id,data')
        .range(from, from + pageSize - 1)
      if (error) {
        this.setStatus(navigator.onLine ? 'error' : 'offline')
        return
      }
      rows.push(...data)
      if (data.length < pageSize) break
    }
    const next = {}
    for (const r of rows) (next[r.collection] ||= {})[r.id] = r.data
    this.data = next
    for (const op of this.queue) this.apply(op)
    this.status = 'online'
    this.emit()
  }

  async flush() {
    if (this.flushing || !this.client || !this.session) return
    this.flushing = true
    try {
      while (this.queue.length) {
        const op = this.queue[0]
        let error
        if (op.type === 'put') {
          ;({ error } = await this.client.from('items').upsert(
            op.rows.map(({ id, ...data }) => ({ collection: op.collection, id, data })),
          ))
        } else {
          ;({ error } = await this.client.from('items').delete().eq('collection', op.collection).in('id', op.ids))
        }
        if (error) {
          this.setStatus(navigator.onLine ? 'error' : 'offline')
          setTimeout(() => this.flush(), 5000)
          return
        }
        this.queue.shift()
        writeJson(QUEUE_KEY, this.queue)
      }
      if (this.status !== 'online') this.setStatus('online')
    } finally {
      this.flushing = false
    }
  }
}

export const store = new Store()
