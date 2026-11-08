// Zutaten verstehen ("375g Kartoffeln", "1 EL Öl", "½ Bund Petersilie", "Salz")
// und für die Einkaufsliste zusammenrechnen.

// canonical: wie die Einheit angezeigt wird, base: worauf umgerechnet wird, factor: Umrechnung
const UNITS = [
  [['kg', 'kilo', 'kilogramm'], { canonical: 'g', factor: 1000 }],
  [['g', 'gr', 'gramm'], { canonical: 'g', factor: 1 }],
  [['l', 'liter'], { canonical: 'ml', factor: 1000 }],
  [['dl'], { canonical: 'ml', factor: 100 }],
  [['cl'], { canonical: 'ml', factor: 10 }],
  [['ml', 'milliliter'], { canonical: 'ml', factor: 1 }],
  [['el', 'essl', 'esslöffel'], { canonical: 'EL' }],
  [['tl', 'teel', 'teelöffel'], { canonical: 'TL' }],
  [['prise', 'prisen'], { canonical: 'Prise', plural: 'Prisen' }],
  [['bund'], { canonical: 'Bund' }],
  [['dose', 'dosen'], { canonical: 'Dose', plural: 'Dosen' }],
  [['pck', 'pck.', 'päckchen', 'packung', 'packungen', 'pkg', 'pkg.', 'pack'], { canonical: 'Pck.' }],
  [['stück', 'stk', 'stk.'], { canonical: '' }],
  [['zehe', 'zehen'], { canonical: 'Zehe', plural: 'Zehen' }],
  [['becher'], { canonical: 'Becher' }],
  [['glas', 'gläser'], { canonical: 'Glas', plural: 'Gläser' }],
  [['scheibe', 'scheiben'], { canonical: 'Scheibe', plural: 'Scheiben' }],
  [['tasse', 'tassen'], { canonical: 'Tasse', plural: 'Tassen' }],
  [['handvoll'], { canonical: 'Handvoll' }],
  [['msp', 'msp.', 'messerspitze'], { canonical: 'Msp.' }],
  [['zweig', 'zweige'], { canonical: 'Zweig', plural: 'Zweige' }],
  [['blatt', 'blätter'], { canonical: 'Blatt', plural: 'Blätter' }],
  [['kopf', 'köpfe'], { canonical: 'Kopf', plural: 'Köpfe' }],
  [['stange', 'stangen'], { canonical: 'Stange', plural: 'Stangen' }],
  [['würfel'], { canonical: 'Würfel' }],
  [['knolle', 'knollen'], { canonical: 'Knolle', plural: 'Knollen' }],
]

const UNIT_LOOKUP = new Map()
for (const [aliases, info] of UNITS) for (const a of aliases) UNIT_LOOKUP.set(a, info)
const PLURALS = new Map(UNITS.map(([, i]) => [i.canonical, i.plural || i.canonical]))

const FRACTIONS = { '½': 0.5, '¼': 0.25, '¾': 0.75, '⅓': 1 / 3, '⅔': 2 / 3, '⅛': 0.125 }

function parseNumber(raw) {
  if (raw == null) return null
  let s = String(raw).trim().replace(',', '.')
  if (!s) return null
  // Bereich "2-3" -> obere Grenze, damit es sicher reicht
  if (/^[\d.½¼¾⅓⅔⅛\s/]+-[\d.½¼¾⅓⅔⅛\s/]+$/.test(s)) s = s.split('-')[1].trim()
  let total = 0
  for (const part of s.split(/\s+/)) {
    if (FRACTIONS[part] != null) total += FRACTIONS[part]
    else if (/^\d+[½¼¾⅓⅔⅛]$/.test(part)) total += Number(part.slice(0, -1)) + FRACTIONS[part.slice(-1)]
    else if (/^\d+\/\d+$/.test(part)) {
      const [a, b] = part.split('/').map(Number)
      if (!b) return null
      total += a / b
    } else if (/^\d*\.?\d+$/.test(part)) total += Number(part)
    else return null
  }
  return total
}

const NUM = '(?:\\d+[½¼¾⅓⅔⅛]|\\d+\\s+\\d+/\\d+|\\d+/\\d+|\\d+(?:[.,]\\d+)?|[½¼¾⅓⅔⅛])'
const AMOUNT_RE = new RegExp(`^(${NUM}(?:\\s*-\\s*${NUM})?)\\s*(.*)$`)

/**
 * Zerlegt eine Zutat. Akzeptiert Text ("375g Kartoffeln") oder ein Objekt
 * ({ menge: 375, einheit: 'g', name: 'Kartoffeln' }).
 * @returns {{ amount: number|null, unit: string, name: string }}
 */
export function parseIngredient(input) {
  if (input && typeof input === 'object') {
    const name = String(input.name ?? input.zutat ?? '').trim()
    const amount = parseNumber(input.menge ?? input.amount)
    const unitRaw = String(input.einheit ?? input.unit ?? '').trim()
    return normalizeUnit(amount, unitRaw, name)
  }
  const text = String(input ?? '').trim()
  const m = text.match(AMOUNT_RE)
  if (!m) return { amount: null, unit: '', name: text }
  const amount = parseNumber(m[1])
  let rest = m[2].trim()
  // Einheit: erstes Wort (oder direkt an der Zahl, z. B. "375g")
  const um = rest.match(/^([A-Za-zÄÖÜäöüß]+\.?)(?:\s+|$)(.*)$/)
  if (um && UNIT_LOOKUP.has(um[1].toLowerCase()) && um[2].trim()) {
    return normalizeUnit(amount, um[1], um[2].trim())
  }
  return { amount, unit: '', name: rest }
}

function normalizeUnit(amount, unitRaw, name) {
  if (!unitRaw) return { amount, unit: '', name }
  const info = UNIT_LOOKUP.get(unitRaw.toLowerCase())
  if (!info) return { amount, unit: unitRaw, name }
  return {
    amount: amount != null && info.factor ? amount * info.factor : amount,
    unit: info.canonical,
    name,
  }
}

/** Schlüssel, unter dem gleiche Zutaten zusammengefasst werden ("Zwiebeln" == "Zwiebel"). */
export function ingredientKey(name) {
  let k = String(name).toLowerCase().trim().replace(/\s+/g, ' ')
  k = k.replace(/\(.*?\)/g, '').trim()
  if (/[eilr]n$/.test(k) && k.length > 4) k = k.slice(0, -1)
  return k
}

/**
 * Fasst Zutaten mehrerer Rezepte zusammen.
 * @param {{amount:number|null, unit:string, name:string, recipe?:string}[]} list
 */
export function aggregate(list) {
  const map = new Map()
  for (const ing of list) {
    const key = `${ingredientKey(ing.name)}|${ing.unit}`
    const cur = map.get(key)
    if (!cur) {
      map.set(key, { key, name: ing.name, unit: ing.unit, amount: ing.amount, recipes: ing.recipe ? [ing.recipe] : [] })
    } else {
      if (ing.amount != null) cur.amount = (cur.amount ?? 0) + ing.amount
      if (ing.recipe && !cur.recipes.includes(ing.recipe)) cur.recipes.push(ing.recipe)
    }
  }
  return [...map.values()]
}

function fmtNumber(n) {
  if (n == null) return ''
  const whole = Math.floor(n + 1e-9)
  const frac = n - whole
  const fracs = [[0.25, '¼'], [1 / 3, '⅓'], [0.5, '½'], [2 / 3, '⅔'], [0.75, '¾']]
  for (const [v, s] of fracs) if (Math.abs(frac - v) < 0.02) return whole ? `${whole}${s}` : s
  if (frac < 0.02) return String(whole)
  if (frac > 0.98) return String(whole + 1)
  return String(Math.round(n * 10) / 10).replace('.', ',')
}

/** Menge + Einheit hübsch formatiert: 1500 g -> "1,5 kg", 2 Zehe -> "2 Zehen". */
export function formatAmount(amount, unit) {
  if (amount == null) return unit || ''
  if (unit === 'g' || unit === 'ml') {
    if (amount >= 1000) return `${String(Math.round(amount / 100) / 10).replace('.', ',')} ${unit === 'g' ? 'kg' : 'l'}`
    const r = amount >= 100 ? Math.round(amount / 10) * 10 : Math.round(amount)
    return `${r} ${unit}`
  }
  // Stückzahlen auf halbe aufrunden, damit es reicht
  const rounded = Math.ceil(amount * 4 - 1e-9) / 4
  const label = rounded > 1 ? PLURALS.get(unit) ?? unit : unit
  return `${fmtNumber(rounded)}${label ? ' ' + label : ''}`
}
