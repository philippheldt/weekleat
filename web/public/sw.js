// Offline-Unterstützung: App-Dateien und Bilder aus dem Cache, Seite und Rezepte bevorzugt frisch.
const CACHE = 'weekleat-v2'
// Wie lange auf das Netz gewartet wird, bevor die gespeicherte Version angezeigt wird
const NETWORK_TIMEOUT = 1500

self.addEventListener('install', () => self.skipWaiting())
self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))).then(() => self.clients.claim()),
  )
})

self.addEventListener('fetch', (e) => {
  const url = new URL(e.request.url)
  if (e.request.method !== 'GET' || url.origin !== location.origin) return

  const networkFirst = e.request.mode === 'navigate' || url.pathname.endsWith('.yaml') || url.pathname.endsWith('.webmanifest')
  if (networkFirst) {
    const network = fetch(e.request).then((res) => {
      if (res.ok) {
        const copy = res.clone()
        caches.open(CACHE).then((c) => c.put(e.request, copy))
      }
      return res
    })
    const cached = () =>
      caches
        .match(e.request, { ignoreSearch: true })
        .then((r) => r || (e.request.mode === 'navigate' ? caches.match('./') : undefined))
    // Bei schlechtem Netz nicht ewig warten: nach kurzer Zeit die gespeicherte Version nehmen
    const timeout = new Promise((resolve) => setTimeout(resolve, NETWORK_TIMEOUT)).then(cached)
    e.respondWith(
      Promise.race([network.catch(cached), timeout.then((r) => r || network)]).then((r) => r || network),
    )
    e.waitUntil(network.catch(() => {}))
    return
  }
  e.respondWith(
    caches.match(e.request).then(
      (hit) =>
        hit ||
        fetch(e.request).then((res) => {
          if (res.ok) {
            const copy = res.clone()
            caches.open(CACHE).then((c) => c.put(e.request, copy))
          }
          return res
        }),
    ),
  )
})
