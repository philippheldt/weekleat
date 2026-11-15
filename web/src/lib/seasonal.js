// Saisonkalender für Gemüse und Obst (Freiland Deutschland, inkl. Lagerware)
// und passende Alternativen, die zu der Zeit Saison haben.
import { canonicalName } from './canonical.js'

// Monate a..b (über den Jahreswechsel möglich), als Liste 1–12
function months(a, b) {
  const out = []
  for (let m = a; ; m = (m % 12) + 1) {
    out.push(m)
    if (m === b) break
  }
  return out
}
const ALL = months(1, 12)

// Wann gibt es was aus der Region? (Alternativen brauchen das auch)
const AVAILABLE = {
  Paprika: months(7, 10),
  Zucchini: months(6, 9),
  Gurke: months(6, 9),
  'Grüne Bohnen': months(7, 9),
  Blumenkohl: months(6, 11),
  Kürbis: months(9, 1),
  Spargel: months(4, 6),
  Pfifferlinge: months(7, 10),
  Pfirsiche: months(6, 9),
  // Alternativen
  Karotten: ALL,
  Süßkartoffeln: ALL,
  Lauch: ALL,
  Champignons: ALL,
  'Erbsen (TK)': ALL,
  'Brokkoli (TK)': ALL,
  Äpfel: ALL,
  Kräuterseitlinge: ALL,
  Pastinaken: months(10, 3),
  Rosenkohl: months(10, 2),
  Grünkohl: months(11, 2),
  Schwarzwurzeln: months(10, 3),
  Chicorée: months(10, 4),
  Rettich: months(5, 12),
  Radieschen: months(4, 9),
  Kohlrabi: months(5, 10),
  Birnen: months(8, 2),
  Wirsing: months(9, 4),
  'Rote Bete': months(9, 3),
}

// Zutat (einheitlicher Name oder Schreibweise) → Saisongruppe + ähnliche Alternativen
const SEASONAL = [
  [['Paprika', 'Paprika, rot', 'Paprika, gelb', 'Paprika, grün', 'Spitzpaprika'], 'Paprika', ['Karotten', 'Kürbis', 'Süßkartoffeln', 'Rote Bete']],
  [['Zucchini'], 'Zucchini', ['Lauch', 'Pastinaken', 'Champignons', 'Kohlrabi']],
  [['kleine Salatgurken', 'Gurke', 'Salatgurke'], 'Gurke', ['Radieschen', 'Rettich', 'Kohlrabi', 'Chicorée']],
  [['Grüne Bohnen'], 'Grüne Bohnen', ['Erbsen (TK)', 'Rosenkohl', 'Wirsing']],
  [['Blumenkohl'], 'Blumenkohl', ['Rosenkohl', 'Brokkoli (TK)', 'Wirsing']],
  [['Hokkaido-Kürbis', 'Butternut-Kürbis'], 'Kürbis', ['Süßkartoffeln', 'Karotten', 'Pastinaken']],
  [['weißer Spargel', 'Spargel'], 'Spargel', ['Schwarzwurzeln', 'Lauch', 'Kohlrabi']],
  [['Pfifferlinge'], 'Pfifferlinge', ['Champignons', 'Kräuterseitlinge']],
  [['Pfirsiche'], 'Pfirsiche', ['Äpfel', 'Birnen']],
]

const BY_NAME = new Map()
for (const [names, group, alts] of SEASONAL) for (const n of names) BY_NAME.set(n.toLowerCase(), { group, alts })

function lookup(name) {
  return BY_NAME.get(String(name).toLowerCase().trim()) || BY_NAME.get(canonicalName(name).toLowerCase())
}

/** Hat diese Zutat im Monat (1–12) Saison? null = nicht saisonabhängig */
export function inSeason(name, month) {
  const s = lookup(name)
  return s ? AVAILABLE[s.group].includes(month) : null
}

/** Alternativen, die im Monat Saison haben (leer, wenn die Zutat selbst Saison hat). */
export function seasonalAlternatives(name, month) {
  const s = lookup(name)
  if (!s || AVAILABLE[s.group].includes(month)) return []
  return s.alts.filter((a) => (AVAILABLE[a] || ALL).includes(month))
}

/**
 * Saison aus den Zutaten ableiten: In Monaten, in denen eine saisonale Zutat
 * keine Saison hat, kommt das Rezept nur "seltener" (1), sonst normal (2).
 * null, wenn keine saisonale Zutat drin ist.
 */
export function seasonFromIngredients(ingredients) {
  const groups = [...new Set(ingredients.map((i) => lookup(i.name)?.group).filter(Boolean))]
  if (!groups.length) return null
  return Array.from({ length: 12 }, (_, i) => (groups.every((g) => AVAILABLE[g].includes(i + 1)) ? 2 : 1))
}

/** Monat (1–12) einer Planungswoche (Montag als YYYY-MM-DD); Donnerstag entscheidet. */
export function monthOfWeek(week) {
  const d = new Date(week + 'T00:00:00')
  d.setDate(d.getDate() + 3)
  return d.getMonth() + 1
}
