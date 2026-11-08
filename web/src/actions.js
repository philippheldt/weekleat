// Alle Aktionen, die Daten verändern. Jede Aktion schreibt in den gemeinsamen Speicher.
import { store } from './lib/store.js'
import { snapshot } from './state.js'
import { generatePlan, implicitVote } from './lib/generator.js'
import { buildAutoItems, diffShopping } from './lib/shopping.js'
import { parseIngredient } from './lib/ingredients.js'
import { upcomingWeek } from './lib/week.js'

function planOps(plan) {
  return { type: 'put', collection: 'plan', rows: plan.map((d, i) => ({ id: String(i), recipeId: d.recipeId, locked: d.locked })) }
}

function historyOps(s, week, plan) {
  const oldIds = s.history.filter((h) => h.week === week).map((h) => h.id)
  const rows = [...new Set(plan.map((d) => d.recipeId).filter(Boolean))].map((recipeId) => ({
    id: `${week}:${recipeId}`,
    recipeId,
    week,
  }))
  const keep = new Set(rows.map((r) => r.id))
  return [
    { type: 'del', collection: 'history', ids: oldIds.filter((id) => !keep.has(id)) },
    { type: 'put', collection: 'history', rows },
  ]
}

function shoppingOps(s, plan, settings) {
  const auto = buildAutoItems(plan, s.recipes, settings)
  const { upserts, deletes } = diffShopping(s.shopping, auto)
  return [
    { type: 'put', collection: 'shopping', rows: upserts },
    { type: 'del', collection: 'shopping', ids: deletes },
  ]
}

function commitPlan(s, plan, week = s.week, extra = []) {
  store.batch([
    ...extra,
    planOps(plan),
    { type: 'put', collection: 'meta', rows: [{ id: 'plan', week }] },
    ...historyOps(s, week, plan),
    ...shoppingOps(s, plan, s.settings),
  ])
}

/** Ganze Woche (alle nicht festgehaltenen, aktiven Tage) neu planen. */
export function generateWeek() {
  const s = snapshot()
  const week = upcomingWeek()
  // Beim Wechsel in eine neue Woche: Häkchen der alten Einkaufsliste zurücksetzen
  const newWeek = s.planWeek !== week
  const { plan, warnings } = generatePlan({
    recipes: s.recipes,
    settings: s.settings,
    plan: s.plan,
    history: s.history,
    votes: s.votes,
    week,
  })
  if (newWeek) {
    const autos = s.shopping.filter((x) => !x.manual)
    store.remove('shopping', autos.map((x) => x.id))
  }
  commitPlan(snapshot(), plan, week)
  return warnings
}

export function rerollDay(day) {
  const s = snapshot()
  const { plan, warnings } = generatePlan({
    recipes: s.recipes,
    settings: s.settings,
    plan: s.plan,
    history: s.history,
    votes: s.votes,
    week: s.week,
    onlyDay: day,
  })
  plan[day].locked = false
  // Weggewürfeltes Rezept zählt als "seltener"
  const old = s.plan[day].recipeId
  const votes = old && old !== plan[day].recipeId ? [implicitVote(s.week, old, 'reroll')] : []
  commitPlan(s, plan, s.week, [{ type: 'put', collection: 'votes', rows: votes }])
  return warnings
}

export function setDayRecipe(day, recipeId) {
  const s = snapshot()
  const plan = s.plan.map((d) => ({ ...d }))
  plan[day] = { recipeId, locked: !!recipeId }
  // Gezielt ausgewähltes Rezept zählt als "öfter"
  const votes = recipeId ? [implicitVote(s.week, recipeId, 'pick')] : []
  commitPlan(s, plan, s.week, [{ type: 'put', collection: 'votes', rows: votes }])
}

export function toggleLock(day) {
  const s = snapshot()
  const d = s.plan[day]
  store.put('plan', { id: String(day), recipeId: d.recipeId, locked: !d.locked })
}

/** Up-/Downvote für die aktuelle Woche. Nochmal tippen nimmt die Stimme zurück. */
export function vote(recipeId, value) {
  const s = snapshot()
  const id = `${s.week}:${recipeId}`
  const existing = s.votes.find((v) => v.id === id)
  if (existing?.value === value) store.remove('votes', id)
  else store.put('votes', { id, recipeId, week: s.week, value })
}

export function updateSettings(patch) {
  const s = snapshot()
  const settings = { ...s.settings, ...patch, freq: { ...s.settings.freq, ...(patch.freq || {}) } }
  store.batch([
    { type: 'put', collection: 'settings', rows: [{ id: 'main', ...settings }] },
    ...shoppingOps(s, s.plan, settings),
  ])
}

export function toggleDayActive(day) {
  const s = snapshot()
  const days = [...s.settings.days]
  days[day] = !days[day]
  updateSettings({ days })
}

// ---- Einkaufsliste ----
export function addShoppingItem(text) {
  const t = text.trim()
  if (!t) return
  const ing = parseIngredient(t)
  const id = 'm:' + (crypto.randomUUID?.() || Date.now().toString(36) + Math.random().toString(36).slice(2))
  store.put('shopping', { id, name: ing.name || t, amount: ing.amount, unit: ing.unit, manual: true, checked: false, createdAt: Date.now() })
}

export function toggleShopping(item) {
  const { id, ...rest } = item
  store.put('shopping', { id, ...rest, checked: !item.checked })
}

export function removeShopping(ids) {
  store.remove('shopping', ids)
}

/** Gekaufte eigene Einträge löschen. */
export function clearBought() {
  const s = snapshot()
  store.remove('shopping', s.shopping.filter((x) => x.checked && x.manual).map((x) => x.id))
}
