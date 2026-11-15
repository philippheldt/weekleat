// Baut die Einkaufsliste aus dem Wochenplan.
import { aggregate, ingredientKey } from './ingredients.js'
import { withDefaults } from './generator.js'
import { canonicalName } from './canonical.js'

export function pantrySet(settings) {
  return new Set(
    String(settings.pantry || '')
      .split(/[,\n]/)
      .flatMap((s) => [ingredientKey(s), ingredientKey(canonicalName(s))])
      .filter(Boolean),
  )
}

/**
 * Zutaten aller geplanten Tage, auf die gewünschten Portionen umgerechnet und zusammengefasst.
 * @returns {{id:string, name:string, amount:number|null, unit:string, recipes:string[]}[]}
 */
export function buildAutoItems(plan, recipes, rawSettings) {
  const settings = withDefaults(rawSettings)
  const byId = new Map(recipes.map((r) => [r.id, r]))
  const pantry = pantrySet(settings)
  const all = []
  plan.forEach((day, i) => {
    if (!settings.days[i] && !day.locked) return
    const recipe = byId.get(day.recipeId)
    if (!recipe) return
    const factor = settings.portions / recipe.portions
    for (const ing of recipe.ingredients) {
      if (!ing.name || pantry.has(ingredientKey(ing.name)) || pantry.has(ingredientKey(canonicalName(ing.name)))) continue
      all.push({ ...ing, amount: ing.amount != null ? ing.amount * factor : null, recipe: recipe.title })
    }
  })
  return aggregate(all)
    .map(({ key, ...rest }) => ({ id: 'auto:' + key, ...rest }))
    .sort((a, b) => a.name.localeCompare(b.name, 'de'))
}

/**
 * Vergleicht neue automatische Einträge mit der gespeicherten Liste.
 * Eigene Einträge bleiben unberührt, Häkchen bleiben erhalten.
 * @returns {{ upserts: object[], deletes: string[] }}
 */
export function diffShopping(existing, autoItems) {
  const autos = existing.filter((x) => !x.manual)
  const old = new Map(autos.map((x) => [x.id, x]))
  const upserts = []
  for (const item of autoItems) {
    const prev = old.get(item.id)
    // Neue Zeile, die alte Zeilen zusammenfasst (z. B. "Kochsahne" + "Sahne" → "Sahne"):
    // abgehakt, wenn alle alten Zeilen dazu abgehakt waren
    const merged = autos.filter(
      (x) => x === prev || ingredientKey(canonicalName(x.name)) === ingredientKey(item.name),
    )
    const checked = merged.length > 0 && merged.every((x) => x.checked)
    const next = { ...item, manual: false, checked }
    if (!prev || prev.amount !== next.amount || prev.name !== next.name || String(prev.recipes) !== String(next.recipes)) {
      upserts.push(next)
    }
    old.delete(item.id)
  }
  return { upserts, deletes: [...old.keys()] }
}
