// Erstellt den Wochenplan: gewichteter Zufall aus Häufigkeit, Bewertungen und Abwechslung.
import { DAY_KEYS, weeksBetween } from './week.js'

export const FREQ_OPTIONS = ['nie', 'selten', 'mittel', 'häufig']
export const FREQ_FACTOR = { nie: 0, selten: 0.4, mittel: 1, häufig: 2.2 }
/** Wie viele Fleisch-/Fischgerichte pro Woche (bei 7 Tagen, wird auf weniger Tage umgerechnet) */
export const MEAT_PER_WEEK = { nie: 0, selten: 1, mittel: 2, häufig: 4 }

export const DEFAULT_SETTINGS = {
  days: [true, true, true, true, true, true, true],
  portions: 4,
  freq: { nudeln: 'häufig', reis: 'mittel', kartoffeln: 'mittel', gebackenes: 'selten', sonstiges: 'mittel' },
  diet: 'alles',
  meat: 'selten',
  noRepeatWeeks: 2,
  pantry: 'Salz, Pfeffer, Öl, Wasser',
}

export function withDefaults(s) {
  return {
    ...DEFAULT_SETTINGS,
    ...(s || {}),
    freq: { ...DEFAULT_SETTINGS.freq, ...(s?.freq || {}) },
    days: Array.isArray(s?.days) && s.days.length === 7 ? s.days : DEFAULT_SETTINGS.days,
  }
}

const isMeat = (r) => r.diet === 'fleisch' || r.diet === 'fisch'

export function allowedByDiet(recipe, diet) {
  if (diet === 'vegan') return recipe.diet === 'vegan'
  if (diet === 'vegetarisch') return recipe.diet === 'vegan' || recipe.diet === 'vegetarisch'
  return true
}

/** Summe aller Up-/Downvotes je Rezept */
export function scores(votes) {
  const map = {}
  for (const v of votes) map[v.recipeId] = (map[v.recipeId] || 0) + (v.value || 0)
  return map
}

/**
 * Automatische Stimme aus dem Verhalten: Neu würfeln = −1, gezielt auswählen = +1.
 * Höchstens eine pro Rezept, Art und Woche – mehrfaches Würfeln zählt nicht mehrfach.
 * Getrennt von den Knöpfen gespeichert (eigene id), fließt aber in die Gewichtung ein.
 */
export function implicitVote(week, recipeId, kind) {
  return { id: `${week}:${recipeId}:${kind}`, recipeId, week, value: kind === 'reroll' ? -1 : 1, auto: true }
}

export function voteFactor(score = 0) {
  return Math.min(5, Math.max(0.15, Math.pow(1.3, score)))
}

/** Grundgewicht eines Rezepts (ohne Tagesbezug) – auch für die Anzeige im Katalog. */
export function baseWeight(recipe, settings, scoreMap) {
  return (FREQ_FACTOR[settings.freq[recipe.category]] ?? 1) * voteFactor(scoreMap[recipe.id])
}

function pickWeighted(items, weights, random) {
  const total = weights.reduce((a, b) => a + b, 0)
  if (total <= 0) return null
  let r = random() * total
  for (let i = 0; i < items.length; i++) {
    r -= weights[i]
    if (r < 0) return items[i]
  }
  return items[items.length - 1]
}

function shuffle(arr, random) {
  const a = [...arr]
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(random() * (i + 1))
    ;[a[i], a[j]] = [a[j], a[i]]
  }
  return a
}

/**
 * @param {object} p
 * @param {object[]} p.recipes      Rezepte aus dem Katalog
 * @param {object}   p.settings     Einstellungen (siehe DEFAULT_SETTINGS)
 * @param {{recipeId:string|null, locked:boolean}[]} p.plan  aktueller Plan (7 Tage)
 * @param {{recipeId:string, week:string}[]} p.history  früher geplante Rezepte
 * @param {{recipeId:string, value:number}[]} p.votes
 * @param {string} p.week           Montag der Woche, die geplant wird
 * @param {number} [p.onlyDay]      nur diesen Tag neu würfeln
 * @param {() => number} [p.random]
 * @returns {{ plan: {recipeId:string|null, locked:boolean}[], warnings: string[] }}
 */
export function generatePlan({ recipes, settings: rawSettings, plan, history = [], votes = [], week, onlyDay, random = Math.random }) {
  const settings = withDefaults(rawSettings)
  const byId = new Map(recipes.map((r) => [r.id, r]))
  const scoreMap = scores(votes)
  const warnings = []

  const current = Array.from({ length: 7 }, (_, i) => ({
    recipeId: plan?.[i]?.recipeId && byId.has(plan[i].recipeId) ? plan[i].recipeId : null,
    locked: !!plan?.[i]?.locked,
  }))

  // Welche Tage werden neu belegt?
  const targets = []
  for (let i = 0; i < 7; i++) {
    if (onlyDay != null ? i === onlyDay : settings.days[i] && !current[i].locked) targets.push(i)
  }
  const result = current.map((d, i) => ({
    recipeId: targets.includes(i) ? null : onlyDay != null || settings.days[i] || d.locked ? d.recipeId : null,
    locked: d.locked,
  }))

  // Kürzlich gekochte Rezepte (in den letzten N Wochen vor dieser Woche)
  const recent = new Set(
    history
      .filter((h) => {
        const diff = weeksBetween(h.week, week)
        return diff >= 1 && diff <= settings.noRepeatWeeks
      })
      .map((h) => h.recipeId),
  )

  const pool = recipes.filter((r) => r.plannable !== false && allowedByDiet(r, settings.diet))
  if (!pool.length) {
    warnings.push('Keine Rezepte passen zur gewählten Ernährungsweise.')
    return { plan: result, warnings }
  }

  // Fleisch-Tage festlegen, damit die Woche zur Einstellung passt
  const slotType = {}
  if (settings.diet === 'alles') {
    if (onlyDay != null) {
      const old = byId.get(current[onlyDay].recipeId)
      if (old) slotType[onlyDay] = isMeat(old) ? 'meat' : 'veg'
    } else {
      const activeDays = settings.days.filter(Boolean).length || 7
      const wanted = Math.round((MEAT_PER_WEEK[settings.meat] ?? 1) * (activeDays / 7))
      const fixedMeat = result.filter((d) => d.recipeId && isMeat(byId.get(d.recipeId))).length
      const meatSlots = Math.max(0, Math.min(targets.length, wanted - fixedMeat))
      shuffle(targets, random).forEach((day, idx) => {
        slotType[day] = idx < meatSlots ? 'meat' : 'veg'
      })
    }
  }

  const excludeForDay = onlyDay != null ? current[onlyDay].recipeId : null

  // Lockerungsstufen, falls zu wenige Rezepte passen
  const levels = [
    { recent: true, days: true, slot: true, nie: true, dup: true },
    { recent: false, days: true, slot: true, nie: true, dup: true },
    { recent: false, days: false, slot: true, nie: true, dup: true },
    { recent: false, days: false, slot: false, nie: true, dup: true },
    { recent: false, days: false, slot: false, nie: false, dup: true },
    { recent: false, days: false, slot: false, nie: false, dup: false },
  ]

  for (const day of shuffle(targets, random)) {
    const used = new Set(result.map((d) => d.recipeId).filter(Boolean))
    const neighbours = [result[day - 1]?.recipeId, result[day + 1]?.recipeId]
      .map((id) => byId.get(id)?.category)
      .filter((c) => c && c !== 'sonstiges')

    let chosen = null
    for (const lv of levels) {
      const cands = pool.filter((r) => {
        if (r.id === excludeForDay && pool.length > 1) return false
        if (lv.dup && used.has(r.id)) return false
        if (lv.recent && recent.has(r.id)) return false
        if (lv.days && r.days.length && !r.days.includes(DAY_KEYS[day])) return false
        if (lv.slot && slotType[day] === 'meat' && !isMeat(r)) return false
        if (lv.slot && slotType[day] === 'veg' && isMeat(r)) return false
        if (lv.nie && settings.freq[r.category] === 'nie') return false
        return true
      })
      if (!cands.length) continue
      const weights = cands.map((r) => {
        let w = baseWeight(r, settings, scoreMap)
        if (!lv.nie && w === 0) w = 0.05
        if (neighbours.includes(r.category)) w *= 0.35
        return w
      })
      chosen = pickWeighted(cands, weights, random)
      if (chosen) {
        if (lv !== levels[0] && onlyDay == null && !warnings.length) {
          warnings.push('Nicht genug passende Rezepte – einige Regeln wurden gelockert. Mehr Rezepte im Katalog helfen.')
        }
        break
      }
    }
    result[day].recipeId = chosen ? chosen.id : null
  }

  return { plan: result, warnings }
}
