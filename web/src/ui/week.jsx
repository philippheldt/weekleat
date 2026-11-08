import { useRef, useState } from 'preact/hooks'
import { DAYS, DAY_LETTERS, dateOfDay, formatShort, weekLabel, weekdayIndex, mondayOf } from '../lib/week.js'
import { scores } from '../lib/generator.js'
import { generateWeek, rerollDay, toggleDayActive } from '../actions.js'
import { Banner, Chevron, FoodImage, Icon, NavBar, RecipeTags, Svg, toast } from './common.jsx'
import { DaySheet } from './day.jsx'
import { SettingsSheet } from './settings.jsx'
import { imageUrl } from '../lib/images.js'

function isoOf(d) {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

/** Karte, die man nach links wischen kann, um den Tag neu zu würfeln (wie in der iOS-App). */
function SwipeCard({ onSwipe, onTap, large, children, label }) {
  const ref = useRef()
  const start = useRef(null)
  const [dx, setDx] = useState(0)
  const [phase, setPhase] = useState('idle') // idle | drag | out | in

  const down = (e) => {
    if (phase === 'out' || phase === 'in') return
    start.current = { x: e.clientX, y: e.clientY, id: e.pointerId, moved: false, horizontal: null }
  }
  const move = (e) => {
    const s = start.current
    if (!s || s.id !== e.pointerId) return
    const x = e.clientX - s.x
    const y = e.clientY - s.y
    if (s.horizontal == null && (Math.abs(x) > 8 || Math.abs(y) > 8)) {
      s.horizontal = Math.abs(x) > Math.abs(y)
      if (s.horizontal) ref.current?.setPointerCapture?.(e.pointerId)
    }
    if (s.horizontal) {
      s.moved = true
      setPhase('drag')
      setDx(Math.min(0, x))
    }
  }
  const up = () => {
    const s = start.current
    start.current = null
    if (!s) return
    if (!s.moved) {
      setPhase('idle')
      return
    }
    const width = ref.current?.offsetWidth || 300
    if (dx < -width * 0.4) {
      navigator.vibrate?.(15)
      setPhase('out')
      setDx(-width * 1.6)
      setTimeout(() => {
        onSwipe()
        setPhase('in')
        setDx(0)
        setTimeout(() => setPhase('idle'), 320)
      }, 260)
    } else {
      setPhase('idle')
      setDx(0)
    }
  }
  const click = (e) => {
    if (phase !== 'idle') return e.preventDefault()
    onTap()
  }

  const style = {
    transform:
      phase === 'in'
        ? 'scale(1)'
        : `translateX(${dx}px) rotate(${dx / 60}deg) scale(${1 - Math.min(0.08, Math.abs(dx) / 3000)})`,
    opacity: phase === 'out' ? 0 : 1,
  }
  return (
    <div class="day-wrap">
      {phase === 'drag' && dx < -30 && (
        <div class="swipe-hint">
          <Svg name="refresh" /> neu würfeln
        </div>
      )}
      <button
        ref={ref}
        class={`card ${large ? 'large' : ''} ${phase === 'drag' ? 'swiping' : 'animate'} ${phase === 'in' ? 'pop' : ''}`}
        style={style}
        onPointerDown={down}
        onPointerMove={move}
        onPointerUp={up}
        onPointerCancel={up}
        onClick={click}
        aria-label={label}
      >
        {children}
      </button>
    </div>
  )
}

function DayCard({ app, day, large, onOpen }) {
  const entry = app.plan[day]
  const recipe = app.byId.get(entry.recipeId)
  const scoreMap = scores(app.votes)

  if (!app.settings.days[day] && !entry.locked) {
    return <div class="card empty">Heute wird nicht gekocht</div>
  }
  if (!entry.recipeId) {
    return (
      <button class="card empty" onClick={onOpen}>
        Noch nichts geplant – tippen zum Auswählen
      </button>
    )
  }
  if (!recipe) {
    return (
      <button class="card missing" onClick={onOpen}>
        Dieses Rezept steht nicht mehr in rezepte.yaml – tippen, um ein anderes zu wählen.
      </button>
    )
  }

  const side = (
    <div class="card-side">
      {entry.locked && (
        <span class="lock-on" title="festgehalten">
          <Svg name="lock" size={18} />
        </span>
      )}
      <Chevron />
    </div>
  )
  const swipe = () => {
    const w = rerollDay(day)
    if (w.length) toast(w[0])
  }
  return (
    <SwipeCard onSwipe={swipe} onTap={onOpen} large={large} label={`${DAYS[day]}: ${recipe.title}`}>
      {large ? (
        <>
          <Banner name={recipe.image} />
          <div class="card-row">
            <div class="card-body">
              <div class="card-title">{recipe.title}</div>
              <RecipeTags recipe={recipe} score={scoreMap[recipe.id]} portions={app.settings.portions} />
            </div>
            {side}
          </div>
        </>
      ) : (
        <>
          <FoodImage name={recipe.image} />
          <div class="card-body">
            <div class="card-title">{recipe.title}</div>
            <RecipeTags recipe={recipe} score={scoreMap[recipe.id]} portions={app.settings.portions} />
          </div>
          {side}
        </>
      )}
    </SwipeCard>
  )
}

export function WeekView({ app }) {
  const [openDay, setOpenDay] = useState(null)
  const [settingsOpen, setSettingsOpen] = useState(false)
  const [spinning, setSpinning] = useState(false)

  const hasPlan = !!app.planWeek && app.plan.some((d) => d.recipeId)
  const thisMonday = isoOf(mondayOf())
  const todayIdx = app.week === thisMonday ? weekdayIndex() : -1
  const openCount = app.shopping.filter((x) => !x.checked).length

  const generate = () => {
    if (!app.recipes.length) return toast('Keine Rezepte im Katalog.')
    setSpinning(true)
    setTimeout(() => setSpinning(false), 600)
    navigator.vibrate?.(20)
    const w = generateWeek()
    if (w.length) toast(w[0])
  }

  const order = [0, 1, 2, 3, 4, 5, 6]

  return (
    <>
      <NavBar
        left={
          <a class="nav-btn" href="#/rezepte" aria-label="Rezeptsammlung">
            <Icon name="book-black" />
          </a>
        }
        title="Wochenplan"
        sub={hasPlan ? weekLabel(app.week) : null}
        right={
          <a class="nav-btn" href="#/einkauf" aria-label={`Einkaufsliste, ${openCount} offen`}>
            <Icon name="cart-black" />
            {openCount > 0 && <span class="badge">{openCount}</span>}
          </a>
        }
      />

      <div class="days" role="group" aria-label="An welchen Tagen wird gekocht?">
        {DAY_LETTERS.map((l, i) => (
          <button
            key={i}
            class={`day-toggle ${app.settings.days[i] ? 'on' : ''} ${i === todayIdx ? 'today' : ''}`}
            aria-pressed={app.settings.days[i]}
            aria-label={DAYS[i]}
            onClick={() => toggleDayActive(i)}
          >
            {l}
          </button>
        ))}
      </div>

      {app.catalogError && <div class="notice warn">{app.catalogError}</div>}

      {!hasPlan ? (
        <div class="empty-state">
          <img src={imageUrl('pizza')} alt="" />
          <p>Sieht ziemlich leer aus hier…</p>
          <span class="muted small">
            {app.recipes.length
              ? `${app.recipes.length} Rezepte im Katalog. Tippe auf „Rezepte generieren“.`
              : 'Lade Rezepte…'}
          </span>
        </div>
      ) : (
        order.map((day) => {
          const date = dateOfDay(app.week, day)
          const isToday = day === todayIdx
          return (
            <section key={day} class={todayIdx > day ? 'past' : ''}>
              {isToday ? (
                <div class="page-head" style={{ paddingBottom: '12px' }}>
                  <h1 class="title">Heute</h1>
                  <div class="caption">
                    {DAYS[day]}, {formatShort(date)}
                  </div>
                </div>
              ) : (
                <div class="section-head caption">
                  {DAYS[day]} · {formatShort(date)}
                </div>
              )}
              <DayCard app={app} day={day} large={isToday} onOpen={() => setOpenDay(day)} />
            </section>
          )
        })
      )}

      <div class="bottom-bar">
        <div class="bottom-bar-inner">
          <button class="btn square" aria-label="Einstellungen" onClick={() => setSettingsOpen(true)}>
            <Icon name="settings-black" />
          </button>
          <button class="btn primary" onClick={generate} disabled={!app.catalogLoaded}>
            <Svg name="refresh" class={spinning ? 'spin' : ''} />
            Rezepte generieren
          </button>
        </div>
      </div>

      {openDay != null && <DaySheet app={app} day={openDay} onClose={() => setOpenDay(null)} />}
      {settingsOpen && <SettingsSheet app={app} onClose={() => setSettingsOpen(false)} />}
    </>
  )
}
