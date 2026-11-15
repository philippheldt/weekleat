import { useEffect, useRef, useState } from 'preact/hooks'
import { DAYS, DAY_LETTERS, dateOfDay, formatShort, weekLabel, weekdayIndex, mondayOf } from '../lib/week.js'
import { generateWeek, rerollDay, swapDays, toggleDayActive } from '../actions.js'
import { Banner, Chevron, FoodImage, Icon, NavBar, Svg, toast } from './common.jsx'
import { DaySheet } from './day.jsx'
import { SettingsSheet } from './settings.jsx'
import { imageUrl } from '../lib/images.js'

function isoOf(d) {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

const LONG_PRESS_MS = 400

/**
 * Karte mit Gesten:
 *  nach rechts wischen → neu würfeln (Karte fliegt raus, neues Rezept kommt)
 *  nach links wischen  → bearbeiten (anderes Rezept auswählen)
 *  lange drücken + ziehen → auf einen anderen Tag verschieben (Drag & Drop)
 */
function SwipeCard({ onSwipeRight, onSwipeLeft, onTap, onLift, onLiftMove, onLiftEnd, large, children, label }) {
  const ref = useRef()
  const start = useRef(null)
  const lifted = useRef(false)
  const pressTimer = useRef(null)
  const [liftDy, setLiftDy] = useState(null)

  // Während die Karte angehoben ist, darf die Seite nicht scrollen
  useEffect(() => {
    const el = ref.current
    if (!el) return
    const block = (e) => lifted.current && e.cancelable && e.preventDefault()
    el.addEventListener('touchmove', block, { passive: false })
    return () => el.removeEventListener('touchmove', block)
  }, [])

  // Nach einer Wischbewegung feuert der Browser noch einen Klick – den ignorieren
  const suppressClick = useRef(false)
  const [dx, setDx] = useState(0)
  const [phase, setPhase] = useState('idle') // idle | drag | out | in

  const down = (e) => {
    if (phase === 'out' || phase === 'in') return
    start.current = { x: e.clientX, y: e.clientY, id: e.pointerId, moved: false, horizontal: null }
    clearTimeout(pressTimer.current)
    if (onLift) {
      pressTimer.current = setTimeout(() => {
        const s = start.current
        if (!s || s.horizontal != null) return
        lifted.current = true
        s.moved = true
        ref.current?.setPointerCapture?.(s.id)
        navigator.vibrate?.(20)
        setLiftDy(0)
        onLift()
      }, LONG_PRESS_MS)
    }
  }
  const move = (e) => {
    const s = start.current
    if (!s || s.id !== e.pointerId) return
    const x = e.clientX - s.x
    const y = e.clientY - s.y
    if (lifted.current) {
      setLiftDy(y)
      onLiftMove(e.clientX, e.clientY)
      return
    }
    if (Math.abs(x) > 8 || Math.abs(y) > 8) clearTimeout(pressTimer.current)
    if (s.horizontal == null && (Math.abs(x) > 8 || Math.abs(y) > 8)) {
      s.horizontal = Math.abs(x) > Math.abs(y)
      if (s.horizontal) ref.current?.setPointerCapture?.(e.pointerId)
    }
    if (s.horizontal) {
      s.moved = true
      setPhase('drag')
      // nach links nur ein Stück ziehen (Bearbeiten), nach rechts frei (Würfeln)
      setDx(x < 0 ? Math.max(x, -(ref.current?.offsetWidth || 300) * 0.55) : x)
    }
  }
  const up = (e) => {
    clearTimeout(pressTimer.current)
    const s = start.current
    start.current = null
    if (!s) return
    if (lifted.current) {
      lifted.current = false
      suppressClick.current = true
      setTimeout(() => (suppressClick.current = false), 400)
      setLiftDy(null)
      onLiftEnd(e?.type !== 'pointercancel')
      return
    }
    if (!s.moved) {
      setPhase('idle')
      return
    }
    suppressClick.current = true
    setTimeout(() => (suppressClick.current = false), 400)
    const width = ref.current?.offsetWidth || 300
    if (dx > width * 0.35) {
      navigator.vibrate?.(15)
      setPhase('out')
      setDx(width * 1.6)
      setTimeout(() => {
        onSwipeRight()
        setPhase('in')
        setDx(0)
        setTimeout(() => setPhase('idle'), 320)
      }, 260)
    } else if (dx < -width * 0.3) {
      navigator.vibrate?.(10)
      setPhase('idle')
      setDx(0)
      onSwipeLeft()
    } else {
      setPhase('idle')
      setDx(0)
    }
  }
  const click = (e) => {
    if (suppressClick.current || phase !== 'idle') return e.preventDefault()
    onTap()
  }

  const style = liftDy != null ? { transform: `translateY(${liftDy}px) scale(1.03)`, zIndex: 30 } : {
    transform:
      phase === 'in'
        ? 'scale(1)'
        : `translateX(${dx}px) rotate(${dx > 0 ? dx / 60 : 0}deg) scale(${1 - Math.min(0.08, Math.abs(dx) / 3000)})`,
    opacity: phase === 'out' ? 0 : 1,
  }
  return (
    <div class="day-wrap">
      {phase === 'drag' && dx > 30 && (
        <div class="swipe-hint left">
          <Svg name="refresh" /> neu würfeln
        </div>
      )}
      {phase === 'drag' && dx < -30 && (
        <div class="swipe-hint right">
          anderes wählen <Svg name="pencil" />
        </div>
      )}
      <button
        ref={ref}
        class={`card ${large ? 'large' : ''} ${phase === 'drag' || liftDy != null ? 'swiping' : 'animate'} ${phase === 'in' ? 'pop' : ''} ${liftDy != null ? 'lifted' : ''}`}
        onContextMenu={(e) => e.preventDefault()}
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

function DayCard({ app, day, large, onOpen, onEdit, drag }) {
  const entry = app.plan[day]
  const recipe = app.byId.get(entry.recipeId)

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
  if (!recipe && !app.catalogLoaded) {
    // Katalog lädt noch (nur beim allerersten Start): Platzhalter statt Fehlermeldung
    return (
      <div class="card skeleton" aria-busy="true">
        <div class="card-img" />
        <div class="card-body">
          <div class="sk-line" />
          <div class="sk-line short" />
        </div>
      </div>
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
          <Svg name="pin" size={18} />
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
    <SwipeCard
      onSwipeRight={swipe}
      onSwipeLeft={onEdit}
      onTap={onOpen}
      onLift={() => drag.start(day)}
      onLiftMove={drag.move}
      onLiftEnd={drag.end}
      large={large}
      label={`${DAYS[day]}: ${recipe.title}`}
    >
      {large ? (
        <>
          <Banner name={recipe.image} />
          <div class="card-row">
            <div class="card-body">
              <div class="card-title">{recipe.title}</div>
            </div>
            {side}
          </div>
        </>
      ) : (
        <>
          <FoodImage name={recipe.image} />
          <div class="card-body">
            <div class="card-title">{recipe.title}</div>
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

  // Drag & Drop zwischen Tagen
  const [dragFrom, setDragFrom] = useState(null)
  const [dragOver, setDragOver] = useState(null)
  const overRef = useRef(null)
  const canDrop = (d) => d != null && (app.settings.days[d] || app.plan[d].locked)
  const drag = {
    start(day) {
      setDragFrom(day)
      overRef.current = day
      setDragOver(day)
    },
    move(x, y) {
      // Nahe am Rand automatisch scrollen
      const edge = 90
      if (y < edge) window.scrollBy(0, -12)
      else if (y > window.innerHeight - edge - 70) window.scrollBy(0, 12)
      // die angehobene Karte selbst liegt unter dem Finger – darunter nach dem Tag suchen
      const el = document
        .elementsFromPoint(x, y)
        .find((n) => !n.closest('.card.lifted') && n.closest('[data-day]'))
        ?.closest('[data-day]')
      const d = el ? Number(el.dataset.day) : null
      if (d !== overRef.current) {
        overRef.current = d
        setDragOver(d)
        if (d != null) navigator.vibrate?.(5)
      }
    },
    end(commit) {
      const from = dragFromRef.current
      const to = overRef.current
      setDragFrom(null)
      setDragOver(null)
      overRef.current = null
      if (commit && from != null && canDrop(to) && to !== from) {
        swapDays(from, to)
        const moved = app.byId.get(app.plan[from].recipeId)?.title
        toast(app.plan[to].recipeId ? `${DAYS[from]} und ${DAYS[to]} getauscht` : `${moved} auf ${DAYS[to]} verschoben`)
      }
    },
  }
  const dragFromRef = useRef(null)
  dragFromRef.current = dragFrom

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
            <section
              key={day}
              data-day={day}
              class={`${todayIdx > day ? 'past' : ''} ${dragFrom != null && dragOver === day && day !== dragFrom ? (canDrop(day) ? 'drop-target' : 'drop-blocked') : ''} ${dragFrom === day ? 'drag-source' : ''}`}
            >
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
              <DayCard app={app} day={day} large={isToday} onOpen={() => setOpenDay({ day })} onEdit={() => setOpenDay({ day, pick: true })} drag={drag} />
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

      {openDay != null && (
        <DaySheet app={app} day={openDay.day} startPicking={openDay.pick} onClose={() => setOpenDay(null)} />
      )}
      {settingsOpen && <SettingsSheet app={app} onClose={() => setSettingsOpen(false)} />}
    </>
  )
}
