import { render } from 'preact'
import { App } from './app.jsx'
import { store } from './lib/store.js'
import { loadCatalog } from './state.js'
import './styles.css'

// Sofort mit dem gespeicherten Stand anzeigen, Server-Abgleich läuft im Hintergrund
render(<App />, document.getElementById('app'))
store.init()
loadCatalog()

// Katalog neu laden, wenn die App wieder in den Vordergrund kommt
document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'visible') loadCatalog()
})

if ('serviceWorker' in navigator && import.meta.env.PROD) {
  navigator.serviceWorker.register(`${import.meta.env.BASE_URL}sw.js`).catch(() => {})
}
