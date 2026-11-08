import { useEffect, useState } from 'preact/hooks'
import { useApp } from './state.js'
import { store, syncEnabled } from './lib/store.js'
import { imageUrl } from './lib/images.js'
import { WeekView } from './ui/week.jsx'
import { CatalogView } from './ui/catalog.jsx'
import { ShoppingView } from './ui/shopping.jsx'
import { Toast } from './ui/common.jsx'

function useRoute() {
  const [route, setRoute] = useState(location.hash.replace(/^#/, '') || '/')
  useEffect(() => {
    const on = () => {
      setRoute(location.hash.replace(/^#/, '') || '/')
      window.scrollTo(0, 0)
    }
    window.addEventListener('hashchange', on)
    return () => window.removeEventListener('hashchange', on)
  }, [])
  return route
}

function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)
  const submit = async (e) => {
    e.preventDefault()
    setBusy(true)
    setError('')
    try {
      await store.signIn(email.trim(), password)
    } catch (err) {
      setError(
        err.message === 'Invalid login credentials'
          ? 'E-Mail oder Passwort falsch.'
          : /fetch|network/i.test(err.message)
            ? 'Keine Verbindung zum Server.'
            : err.message,
      )
    } finally {
      setBusy(false)
    }
  }
  return (
    <form class="login" onSubmit={submit}>
      <img src={imageUrl('pizza')} alt="" />
      <h1 class="title">weekleat</h1>
      <p class="muted" style={{ textAlign: 'center', margin: '0 0 8px' }}>
        Mit eurem gemeinsamen Haushalts-Login anmelden.
      </p>
      <input class="input" type="email" autocomplete="username" placeholder="E-Mail" value={email} onInput={(e) => setEmail(e.currentTarget.value)} required />
      <input class="input" type="password" autocomplete="current-password" placeholder="Passwort" value={password} onInput={(e) => setPassword(e.currentTarget.value)} required />
      {error && <div class="error">{error}</div>}
      <button class="btn primary block" disabled={busy}>
        {busy ? 'Anmelden…' : 'Anmelden'}
      </button>
    </form>
  )
}

export function App() {
  const app = useApp()
  const route = useRoute()

  if (syncEnabled && !app.session) return <Login />

  return (
    <div class="app">
      {route === '/rezepte' ? (
        <CatalogView app={app} />
      ) : route === '/einkauf' ? (
        <ShoppingView app={app} />
      ) : (
        <WeekView app={app} />
      )}
      <Toast />
    </div>
  )
}
