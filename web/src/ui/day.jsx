import { useState } from 'preact/hooks'
import { DAYS, DAY_LETTERS, DAY_KEYS } from '../lib/week.js'
import { scores } from '../lib/generator.js'
import { formatAmount } from '../lib/ingredients.js'
import { displayName } from '../lib/canonical.js'
import { setDayRecipe, setSeason, toggleLock, vote } from '../actions.js'
import { MONTH_LETTERS, MONTH_NAMES } from '../lib/catalog.js'
import { Banner, Chevron, FoodImage, Icon, Sheet, Svg, toast } from './common.jsx'

const DAY_NAMES = { mo: 'Mo', di: 'Di', mi: 'Mi', do: 'Do', fr: 'Fr', sa: 'Sa', so: 'So' }

export function VoteButtons({ app, recipe }) {
  const mine = app.votes.find((v) => v.id === `${app.week}:${recipe.id}`)?.value || 0
  const total = scores(app.votes)[recipe.id] || 0
  return (
    <>
      <div class="votes">
        <button class={`btn vote-btn up ${mine === 1 ? 'on' : ''}`} aria-pressed={mine === 1} onClick={() => vote(recipe.id, 1)}>
          <Svg name="more" /> Öfter
        </button>
        <button class={`btn vote-btn down ${mine === -1 ? 'on' : ''}`} aria-pressed={mine === -1} onClick={() => vote(recipe.id, -1)}>
          <Svg name="less" /> Seltener
        </button>
      </div>
      <p class="muted small" style={{ margin: '8px 0 0' }}>
        Öfter oder seltener einplanen · bisher {total > 0 ? `+${total}` : total}
      </p>
    </>
  )
}

/** Wo steht das Rezept? Link zum Original oder Hinweis wie "HelloFresh-Karte". */
export function Source({ recipe }) {
  if (!recipe.source && !recipe.link) return null
  if (recipe.link) {
    return (
      <a class="source" href={recipe.link} target="_blank" rel="noopener">
        <Icon name="book-black" class="icon-sm" />
        <span>
          Rezept bei <strong>{recipe.source || 'Originalseite'}</strong> öffnen
        </span>
        <Svg name="link" size={16} />
      </a>
    )
  }
  return (
    <div class="source">
      <Icon name="book-black" class="icon-sm" />
      <span>
        Quelle: <strong>{recipe.source}</strong>
      </span>
    </div>
  )
}

/** Saison wie die Wochentage: Monate antippen. Nichts oder alles markiert = ganzjährig. */
export function SeasonPicker({ recipe }) {
  const months = recipe.months || []
  const all = months.length === 0
  const toggle = (m) => {
    const base = all ? [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] : months
    const next = base.includes(m) ? base.filter((x) => x !== m) : [...base, m]
    if (next.length === 0) return // mindestens ein Monat bleibt
    setSeason(recipe.id, next)
  }
  const now = new Date().getMonth() + 1
  return (
    <>
      <div class="caption" style={{ marginTop: '22px', display: 'flex', justifyContent: 'space-between' }}>
        <span>Saison</span>
        <span>{all ? 'ganzjährig' : months.includes(now) ? 'gerade Saison' : 'gerade keine Saison'}</span>
      </div>
      <div class="month-pick" role="group" aria-label="Saison">
        {MONTH_LETTERS.map((l, i) => {
          const m = i + 1
          const on = all || months.includes(m)
          return (
            <button
              key={m}
              class={`day-toggle ${on ? 'on' : ''} ${m === now ? 'today' : ''}`}
              aria-pressed={on}
              aria-label={MONTH_NAMES[i]}
              onClick={() => toggle(m)}
            >
              {l}
            </button>
          )
        })}
      </div>
      <p class="muted small" style={{ margin: '6px 0 0' }}>
        {all ? 'Monate abwählen, in denen es das Rezept nicht geben soll.' : 'Außerhalb der Saison wird es nicht automatisch eingeplant.'}
        {!all && (
          <>
            {' '}
            <button class="link-inline" onClick={() => setSeason(recipe.id, [])}>
              Ganzjährig
            </button>
          </>
        )}
      </p>
    </>
  )
}

export function RecipeDetail({ app, recipe, children, bannerLeft, bannerRight }) {
  const factor = app.settings.portions / recipe.portions
  return (
    <>
      <div class="banner-wrap">
        <Banner name={recipe.image} class="sheet-banner" />
        {bannerLeft && <div class="banner-btns left">{bannerLeft}</div>}
        {bannerRight && <div class="banner-btns right">{bannerRight}</div>}
      </div>
      <div class="sheet-body">
        <h3 class="detail-title">{recipe.title}</h3>
        <Source recipe={recipe} />
        {recipe.days.length > 0 && (
          <p class="muted small" style={{ margin: '8px 0 0' }}>
            Nur an: {recipe.days.map((d) => DAY_NAMES[d] || d).join(', ')}
          </p>
        )}
        {children}
        <SeasonPicker recipe={recipe} />
        <div class="caption" style={{ marginTop: '22px' }}>
          Zutaten für {app.settings.portions} Portionen
        </div>
        <ul class="ing-list">
          {recipe.ingredients.map((ing, i) => {
            const amount = ing.amount != null ? ing.amount * factor : null
            return (
              <li key={i}>
                <span>{displayName(ing.name, amount, ing.unit)}</span>
                <span class="ing-amount">{formatAmount(amount, ing.unit)}</span>
              </li>
            )
          })}
        </ul>
        {recipe.note && (
          <>
            <div class="caption" style={{ marginTop: '22px' }}>
              Notiz
            </div>
            <p class="note">{recipe.note}</p>
          </>
        )}
      </div>
    </>
  )
}

export function RecipePicker({ app, title, onPick, onClose }) {
  const [q, setQ] = useState('')
  const list = app.recipes
    .filter((r) => r.title.toLowerCase().includes(q.toLowerCase().trim()))
    .sort((a, b) => a.title.localeCompare(b.title, 'de'))
  return (
    <Sheet title={title} onClose={onClose}>
      <div class="search">
        <Icon name="search-gray" />
        <input class="input" placeholder="Rezept suchen" value={q} onInput={(e) => setQ(e.currentTarget.value)} autoFocus />
      </div>
      <div class="list-gap" style={{ paddingTop: '8px' }}>
        {list.map((r) => (
          <button key={r.id} class="card" onClick={() => onPick(r.id)}>
            <FoodImage name={r.image} />
            <div class="card-body">
              <div class="card-title">{r.title}</div>
            </div>
            <div class="card-side">
              <Chevron />
            </div>
          </button>
        ))}
        {!list.length && <p class="muted" style={{ padding: '0 16px' }}>Nichts gefunden.</p>}
      </div>
    </Sheet>
  )
}

export function DaySheet({ app, day, onClose, startPicking = false }) {
  const [picking, setPicking] = useState(startPicking)
  const entry = app.plan[day]
  const recipe = app.byId.get(entry.recipeId)

  if (picking || !recipe) {
    return (
      <RecipePicker
        app={app}
        title={`Rezept für ${DAYS[day]}`}
        onClose={recipe && !startPicking ? () => setPicking(false) : onClose}
        onPick={(id) => {
          setDayRecipe(day, id)
          toast(`Fest eingeplant für ${DAYS[day]}`)
          // Per Wischgeste geöffnet: direkt zurück zum Wochenplan
          if (startPicking) onClose()
          else setPicking(false)
        }}
      />
    )
  }

  return (
    <Sheet onClose={onClose}>
      <RecipeDetail
        app={app}
        recipe={recipe}
        bannerLeft={
          <button
            class={`banner-btn ${entry.locked ? 'on' : ''}`}
            aria-pressed={entry.locked}
            aria-label={entry.locked ? 'Nicht mehr festhalten' : 'Festhalten'}
            onClick={() => {
              toggleLock(day)
              toast(entry.locked ? `${DAYS[day]} wird wieder neu geplant` : `${DAYS[day]} festgehalten`)
            }}
          >
            <Svg name="pin" />
          </button>
        }
        bannerRight={
          <button class="banner-btn" aria-label="Anderes Rezept wählen" onClick={() => setPicking(true)}>
            <Svg name="pencil" />
          </button>
        }
      >
        <VoteButtons app={app} recipe={recipe} />
      </RecipeDetail>
    </Sheet>
  )
}

/** Tag-Auswahl, um ein Rezept aus dem Katalog fest einzuplanen */
export function PlanOnDay({ app, recipe, onDone }) {
  return (
    <>
      <div class="caption" style={{ marginTop: '18px' }}>
        Fest einplanen am
      </div>
      <div class="day-pick">
        {DAY_LETTERS.map((l, i) => {
          const here = app.plan[i].recipeId === recipe.id
          return (
            <button
              key={i}
              class={`btn ${here ? 'on' : ''}`}
              aria-label={DAYS[i]}
              onClick={() => {
                setDayRecipe(i, here ? null : recipe.id)
                toast(here ? `${DAYS[i]} wieder frei` : `${recipe.title} am ${DAYS[i]} eingeplant`)
                onDone?.()
              }}
            >
              {DAY_KEYS[i].replace(/^./, (c) => c.toUpperCase())}
            </button>
          )
        })}
      </div>
    </>
  )
}
