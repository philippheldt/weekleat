import { useState } from 'preact/hooks'
import { CATEGORIES, CATEGORY_LABELS } from '../lib/catalog.js'
import { scores } from '../lib/generator.js'
import { BackLink, Chevron, FoodImage, Icon, NavBar, Sheet } from './common.jsx'
import { PlanOnDay, RecipeDetail, VoteButtons } from './day.jsx'

const EDIT_URL = import.meta.env.VITE_RECIPES_EDIT_URL || ''

export function CatalogView({ app }) {
  const [q, setQ] = useState('')
  const [cat, setCat] = useState('alle')
  const [open, setOpen] = useState(null)
  const [sort, setSort] = useState('name')
  const scoreMap = scores(app.votes)

  const list = app.recipes
    .filter((r) => cat === 'alle' || r.category === cat)
    .filter((r) => {
      const s = q.toLowerCase().trim()
      return (
        !s ||
        r.title.toLowerCase().includes(s) ||
        r.source.toLowerCase().includes(s) ||
        r.ingredients.some((i) => i.name.toLowerCase().includes(s))
      )
    })
    .sort((a, b) =>
      sort === 'bewertung'
        ? (scoreMap[b.id] || 0) - (scoreMap[a.id] || 0) || a.title.localeCompare(b.title, 'de')
        : a.title.localeCompare(b.title, 'de'),
    )
  const recipe = open && app.byId.get(open)

  return (
    <>
      <NavBar left={<BackLink />} title="Rezeptsammlung" sub={`${app.recipes.length} Rezepte`} />

      {app.problems.length > 0 && (
        <div class="notice warn">
          <strong>Hinweise zur rezepte.yaml</strong>
          <ul>
            {app.problems.map((p, i) => (
              <li key={i}>{p}</li>
            ))}
          </ul>
        </div>
      )}

      <div class="search">
        <Icon name="search-gray" />
        <input class="input" placeholder="Rezept, Zutat oder Quelle suchen" value={q} onInput={(e) => setQ(e.currentTarget.value)} />
      </div>
      <div class="chips">
        {['alle', ...CATEGORIES].map((c) => (
          <button key={c} class={`chip ${cat === c ? 'on' : ''}`} onClick={() => setCat(c)}>
            {c === 'alle' ? 'Alle' : CATEGORY_LABELS[c]}
          </button>
        ))}
        <span style={{ flex: 1 }} />
        <button class="chip" onClick={() => setSort(sort === 'name' ? 'bewertung' : 'name')}>
          Sortierung: {sort === 'name' ? 'A–Z' : 'Bewertung'}
        </button>
      </div>

      <div class="list-gap" style={{ paddingTop: '12px' }}>
        {list.map((r) => (
          <button key={r.id} class="card" onClick={() => setOpen(r.id)}>
            <FoodImage name={r.image} />
            <div class="card-body">
              <div class="card-title">{r.title}</div>
            </div>
            <div class="card-side">
              <Chevron />
            </div>
          </button>
        ))}
        {app.catalogLoaded && !list.length && <p class="muted" style={{ padding: '0 16px' }}>Keine Rezepte gefunden.</p>}
      </div>

      <div class="notice" style={{ marginTop: '24px' }}>
        Die Rezepte stehen in der Datei <strong>rezepte.yaml</strong>. Neue Lieblingsrezepte dort eintragen – nach dem
        Speichern sind sie hier zu sehen.
        {EDIT_URL && (
          <div style={{ marginTop: '10px' }}>
            <a class="btn small" href={EDIT_URL} target="_blank" rel="noopener">
              rezepte.yaml bearbeiten
            </a>
          </div>
        )}
      </div>

      {recipe && (
        <Sheet title="Rezept" onClose={() => setOpen(null)}>
          <RecipeDetail app={app} recipe={recipe}>
            <PlanOnDay app={app} recipe={recipe} />
            <VoteButtons app={app} recipe={recipe} />
          </RecipeDetail>
        </Sheet>
      )}
    </>
  )
}
