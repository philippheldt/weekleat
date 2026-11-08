// Liest den Rezeptkatalog (rezepte.yaml) ein und prüft ihn.
import { load as loadYaml } from 'js-yaml'
import { parseIngredient } from './ingredients.js'
import { chooseImage } from './images.js'

export const CATEGORIES = ['nudeln', 'reis', 'kartoffeln', 'gebackenes', 'sonstiges']
export const CATEGORY_LABELS = {
  nudeln: 'Nudeln',
  reis: 'Reis',
  kartoffeln: 'Kartoffeln',
  gebackenes: 'Gebackenes',
  sonstiges: 'Sonstiges',
}
export const DIETS = ['vegan', 'vegetarisch', 'fisch', 'fleisch']
export const DIET_LABELS = { vegan: 'vegan', vegetarisch: 'vegetarisch', fisch: 'Fisch', fleisch: 'Fleisch' }

const CATEGORY_ALIASES = {
  nudel: 'nudeln', pasta: 'nudeln', nudeln: 'nudeln',
  reis: 'reis', rice: 'reis',
  kartoffel: 'kartoffeln', kartoffeln: 'kartoffeln',
  gebacken: 'gebackenes', gebackenes: 'gebackenes', ofen: 'gebackenes', backofen: 'gebackenes',
  sonstiges: 'sonstiges', anderes: 'sonstiges',
}
const DIET_ALIASES = {
  vegan: 'vegan', vegetarisch: 'vegetarisch', veggie: 'vegetarisch', veggi: 'vegetarisch',
  fisch: 'fisch', fleisch: 'fleisch',
}

const MEAT = ['hack', 'fleisch', 'hähnchen', 'huhn', 'pute', 'speck', 'schinken', 'salami', 'wurst', 'würstchen', 'bacon', 'rind', 'schwein', 'lamm', 'chorizo', 'döner', 'gulasch', 'steak', 'filet', 'kassler', 'leberkäse']
const FISH = ['fisch', 'lachs', 'thunfisch', 'garnele', 'shrimp', 'forelle', 'kabeljau', 'seelachs', 'scampi', 'sardelle']
const ANIMAL = ['ei', 'eier', 'käse', 'milch', 'sahne', 'butter', 'joghurt', 'quark', 'schmand', 'creme', 'crème', 'mozzarella', 'feta', 'parmesan', 'honig', 'paneer', 'frischkäse', 'mascarpone', 'ricotta', 'gouda', 'emmentaler']
const CAT_WORDS = {
  nudeln: ['nudel', 'pasta', 'spaghetti', 'penne', 'spätzle', 'tagliatelle', 'lasagne', 'maultasche', 'gnocchi', 'tortellini', 'fusilli', 'farfalle', 'makkaroni'],
  reis: ['reis', 'risotto', 'biryani', 'paella'],
  kartoffeln: ['kartoffel', 'pommes', 'rösti', 'gnocchi'],
  gebackenes: ['pizza', 'flammkuchen', 'auflauf', 'gratin', 'quiche', 'blech', 'ofen', 'lasagne', 'moussaka'],
}

export function slugify(s) {
  return String(s)
    .toLowerCase()
    .replace(/ä/g, 'ae').replace(/ö/g, 'oe').replace(/ü/g, 'ue').replace(/ß/g, 'ss')
    .normalize('NFD').replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function words(text) {
  return String(text).toLowerCase().split(/[^a-zäöüß]+/).filter(Boolean)
}
function containsAny(ws, list) {
  return ws.some((w) => list.some((k) => (k.length <= 2 ? w === k : w.includes(k))))
}

function toList(v) {
  if (v == null) return []
  if (Array.isArray(v)) return v.map((x) => String(x).trim()).filter(Boolean)
  return String(v).split(',').map((x) => x.trim()).filter(Boolean)
}

/**
 * @param {string} text Inhalt von rezepte.yaml
 * @returns {{ recipes: object[], problems: string[] }}
 */
export function parseCatalog(text) {
  const problems = []
  let data
  try {
    data = loadYaml(text)
  } catch (e) {
    return { recipes: [], problems: [`rezepte.yaml ist kein gültiges YAML: ${e.message}`] }
  }
  const list = Array.isArray(data) ? data : data?.rezepte
  if (!Array.isArray(list)) {
    return { recipes: [], problems: ['rezepte.yaml muss eine Liste unter "rezepte:" enthalten.'] }
  }

  const recipes = []
  const ids = new Set()
  list.forEach((raw, i) => {
    const where = `Rezept ${i + 1}`
    if (!raw || typeof raw !== 'object') {
      problems.push(`${where}: ist leer oder kein Eintrag mit Feldern.`)
      return
    }
    const title = String(raw.titel ?? raw.title ?? '').trim()
    if (!title) {
      problems.push(`${where}: "titel" fehlt.`)
      return
    }
    let id = raw.id ? slugify(raw.id) : slugify(title)
    if (ids.has(id)) {
      problems.push(`"${title}": Die id "${id}" gibt es doppelt. Bitte eine eigene "id:" vergeben.`)
      let n = 2
      while (ids.has(`${id}-${n}`)) n++
      id = `${id}-${n}`
    }
    ids.add(id)

    const ingredients = (Array.isArray(raw.zutaten) ? raw.zutaten : toList(raw.zutaten)).map(parseIngredient)
    if (!ingredients.length) problems.push(`"${title}": hat keine Zutaten.`)
    const tags = toList(raw.tags)
    const ingWords = words(ingredients.map((x) => x.name).join(' '))
    const titleWords = words(title)

    let category = raw.kategorie != null ? CATEGORY_ALIASES[String(raw.kategorie).toLowerCase().trim()] : null
    if (raw.kategorie != null && !category) {
      problems.push(`"${title}": Kategorie "${raw.kategorie}" unbekannt (erlaubt: ${CATEGORIES.join(', ')}).`)
    }
    if (!category) {
      category =
        Object.keys(CAT_WORDS).find((c) => containsAny(titleWords, CAT_WORDS[c])) ||
        tags.map((t) => CATEGORY_ALIASES[t.toLowerCase()]).find(Boolean) ||
        'sonstiges'
    }

    const dietRaw = raw.ernaehrung ?? raw['ernährung']
    let diet = dietRaw != null ? DIET_ALIASES[String(dietRaw).toLowerCase().trim()] : null
    if (dietRaw != null && !diet) {
      problems.push(`"${title}": Ernährung "${dietRaw}" unbekannt (erlaubt: ${DIETS.join(', ')}).`)
    }
    if (!diet) diet = tags.map((t) => DIET_ALIASES[t.toLowerCase()]).find(Boolean)
    if (!diet) {
      const all = [...titleWords, ...ingWords]
      if (containsAny(all, MEAT)) diet = 'fleisch'
      else if (containsAny(all, FISH)) diet = 'fisch'
      else if (containsAny(all, ANIMAL)) diet = 'vegetarisch'
      else diet = 'vegan'
    }

    const portions = Number(raw.portionen ?? raw.portions ?? 4)
    recipes.push({
      id,
      title,
      portions: portions > 0 ? portions : 4,
      category,
      diet,
      tags: tags.filter((t) => !CATEGORY_ALIASES[t.toLowerCase()] && !DIET_ALIASES[t.toLowerCase()]),
      ingredients,
      link: raw.link ? String(raw.link) : '',
      note: String(raw.notiz ?? raw.zubereitung ?? '').trim(),
      image: chooseImage(title, raw.bild),
      days: toList(raw.nur_an ?? raw.tage).map((d) => d.toLowerCase().slice(0, 2)),
    })
  })
  return { recipes, problems }
}
