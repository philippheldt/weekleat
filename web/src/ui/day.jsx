import { useState } from 'preact/hooks'
import { DAYS, DAY_LETTERS, DAY_KEYS } from '../lib/week.js'
import { scores } from '../lib/generator.js'
import { formatAmount } from '../lib/ingredients.js'
import { rerollDay, setDayRecipe, toggleLock, vote } from '../actions.js'
import { Banner, Chevron, FoodImage, Icon, RecipeTags, Sheet, Svg, toast } from './common.jsx'

const DAY_NAMES = { mo: 'Mo', di: 'Di', mi: 'Mi', do: 'Do', fr: 'Fr', sa: 'Sa', so: 'So' }

export function VoteButtons({ app, recipe }) {
  const mine = app.votes.find((v) => v.id === `${app.week}:${recipe.id}`)?.value || 0
  const total = scores(app.votes)[recipe.id] || 0
  return (
    <>
      <div class="votes">
        <button class={`btn vote-btn up ${mine === 1 ? 'on' : ''}`} aria-pressed={mine === 1} onClick={() => vote(recipe.id, 1)}>
          <Svg name="up" /> Gut
        </button>
        <button class={`btn vote-btn down ${mine === -1 ? 'on' : ''}`} aria-pressed={mine === -1} onClick={() => vote(recipe.id, -1)}>
          <Svg name="down" /> Nicht so
        </button>
      </div>
      <p class="muted small" style={{ margin: '8px 0 0' }}>
        Bewertung insgesamt: {total > 0 ? `+${total}` : total} · beeinflusst, wie oft es eingeplant wird
      </p>
    </>
  )
}

export function RecipeDetail({ app, recipe, children }) {
  const factor = app.settings.portions / recipe.portions
  return (
    <>
      <Banner name={recipe.image} class="sheet-banner" />
      <div class="sheet-body">
        <h3 class="detail-title">{recipe.title}</h3>
        <RecipeTags recipe={recipe} portions={app.settings.portions} />
        {recipe.days.length > 0 && (
          <p class="muted small" style={{ margin: '8px 0 0' }}>
            Nur an: {recipe.days.map((d) => DAY_NAMES[d] || d).join(', ')}
          </p>
        )}
        {children}
        <div class="caption" style={{ marginTop: '22px' }}>
          Zutaten für {app.settings.portions} Portionen
        </div>
        <ul class="ing-list">
          {recipe.ingredients.map((ing, i) => (
            <li key={i}>
              <span>{ing.name}</span>
              <span class="ing-amount">{formatAmount(ing.amount != null ? ing.amount * factor : null, ing.unit)}</span>
            </li>
          ))}
        </ul>
        {recipe.note && (
          <>
            <div class="caption" style={{ marginTop: '22px' }}>
              Notiz
            </div>
            <p class="note">{recipe.note}</p>
          </>
        )}
        {recipe.link && (
          <a class="btn block" style={{ marginTop: '16px' }} href={recipe.link} target="_blank" rel="noopener">
            <Svg name="link" /> Originalrezept öffnen
          </a>
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
    <Sheet title={title} onClose={onClose} action={<button class="link-btn" onClick={onClose}>Abbrechen</button>}>
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
              <RecipeTags recipe={r} portions={app.settings.portions} />
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

export function DaySheet({ app, day, onClose }) {
  const [picking, setPicking] = useState(false)
  const entry = app.plan[day]
  const recipe = app.byId.get(entry.recipeId)

  if (picking || !recipe) {
    return (
      <RecipePicker
        app={app}
        title={`Rezept für ${DAYS[day]}`}
        onClose={recipe ? () => setPicking(false) : onClose}
        onPick={(id) => {
          setDayRecipe(day, id)
          toast(`Fest eingeplant für ${DAYS[day]}`)
          setPicking(false)
        }}
      />
    )
  }

  return (
    <Sheet title={DAYS[day]} onClose={onClose}>
      <RecipeDetail app={app} recipe={recipe}>
        <div class="actions">
          <button class={`btn ${entry.locked ? 'on' : ''}`} aria-pressed={entry.locked} onClick={() => toggleLock(day)}>
            <Svg name={entry.locked ? 'lock' : 'unlock'} />
            {entry.locked ? 'Festgehalten' : 'Festhalten'}
          </button>
          <button
            class="btn"
            onClick={() => {
              const w = rerollDay(day)
              if (w.length) toast(w[0])
            }}
          >
            <Svg name="refresh" /> Neu würfeln
          </button>
          <button class="btn" style={{ gridColumn: '1 / -1' }} onClick={() => setPicking(true)}>
            <Svg name="swap" /> Anderes Rezept wählen
          </button>
        </div>
        <p class="muted small" style={{ margin: '4px 0 0' }}>
          Festgehaltene Tage bleiben beim Generieren unverändert.
        </p>
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
