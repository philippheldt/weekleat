import { useEffect, useState } from 'preact/hooks'
import { store } from './lib/store.js'
import { parseCatalog } from './lib/catalog.js'
import { withDefaults } from './lib/generator.js'
import { upcomingWeek } from './lib/week.js'

const CATALOG_CACHE = 'weekleat:catalog'

let catalog = { recipes: [], problems: [], loaded: false, error: '' }
const catalogListeners = new Set()
let catalogText = null

// Zuletzt geladenen Katalog sofort verwenden, die frische Version kommt im Hintergrund
try {
  catalogText = localStorage.getItem(CATALOG_CACHE)
  if (catalogText != null) catalog = { ...parseCatalog(catalogText), loaded: true, error: '' }
} catch {}

export async function loadCatalog() {
  let text = null
  try {
    const res = await fetch(`${import.meta.env.BASE_URL}rezepte.yaml`, { cache: 'no-cache' })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    text = await res.text()
    if (text === catalogText) return
    try {
      localStorage.setItem(CATALOG_CACHE, text)
    } catch {}
  } catch (e) {
    try {
      text = localStorage.getItem(CATALOG_CACHE)
    } catch {}
    if (catalog.loaded) return
    if (text == null) {
      catalog = { recipes: [], problems: [], loaded: true, error: `Rezeptkatalog konnte nicht geladen werden (${e.message}).` }
      catalogListeners.forEach((fn) => fn())
      return
    }
  }
  catalogText = text
  const parsed = parseCatalog(text)
  catalog = { ...parsed, loaded: true, error: '' }
  catalogListeners.forEach((fn) => fn())
}

/** Abgeleiteter App-Zustand aus Speicher + Katalog. */
export function snapshot() {
  const settings = withDefaults(store.get('settings', 'main'))
  const planWeek = store.get('meta', 'plan')?.week || null
  const plan = Array.from({ length: 7 }, (_, i) => {
    const d = store.get('plan', String(i))
    return { recipeId: d?.recipeId ?? null, locked: !!d?.locked }
  })
  return {
    settings,
    plan,
    planWeek,
    week: planWeek || upcomingWeek(),
    votes: store.all('votes'),
    history: store.all('history'),
    shopping: store.all('shopping'),
    recipes: catalog.recipes,
    byId: new Map(catalog.recipes.map((r) => [r.id, r])),
    problems: catalog.problems,
    catalogLoaded: catalog.loaded,
    catalogError: catalog.error,
    status: store.status,
    session: store.session,
  }
}

export function useApp() {
  const [, setTick] = useState(0)
  useEffect(() => {
    const rerender = () => setTick((t) => t + 1)
    const a = store.subscribe(rerender)
    catalogListeners.add(rerender)
    return () => {
      a()
      catalogListeners.delete(rerender)
    }
  }, [])
  return snapshot()
}
