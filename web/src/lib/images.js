// Wählt anhand des Titels eine der Illustrationen (portiert aus RecipieImageLogic.swift).
import meta from '../data/images.json'

const RULES = [
  ['enchilada', ['wraps', 'wrap', 'döner', 'enchilada', 'tasche', 'pita', 'quesadilla', 'burrito', 'taco']],
  ['zucchini', ['zucchini', 'gurke']],
  ['lasagne', ['lasagne', 'auflauf', 'gratin', 'moussaka']],
  ['apricot', ['aprikose']],
  ['brokkoli', ['brokkoli', 'blumenkohl']],
  ['chilli', ['chili', 'chilli', 'spitzpaprika', 'scharf', 'curry', 'masala']],
  ['butter', ['butter', 'margarine', 'magerine']],
  ['carrot', ['karotte', 'pastinake', 'möhre', 'mohrrübe', 'carrot', 'gemüse']],
  ['chicken', ['hähnchen', 'hühner', 'brust', 'schenkel', 'haxe', 'huhn', 'chicken', 'wings', 'pute']],
  ['erbsen', ['erbse', 'peas', 'bohne']],
  ['flambe', ['flammkuchen', 'flambe']],
  ['kloss', ['klöße', 'kloß', 'knödel']],
  ['kokos', ['kokos']],
  ['lauch', ['frühlingszwiebel', 'lauch', 'porree']],
  ['knoblauch', ['knoblauch', 'zwiebel']],
  ['linsen', ['linsen', 'dal']],
  ['mais', ['mais']],
  ['milk', ['milch', 'sahne', 'creme', 'crème', 'schmand', 'joghurt', 'rahm', 'quark']],
  ['paprika', ['paprika']],
  ['radies', ['radieschen']],
  ['sausage', ['wurst', 'würstchen', 'sausage', 'hotdog', 'salami', 'lyoner', 'wiener']],
  ['spice', ['pfeffer', 'salz', 'pulver', 'koriander', 'schnittlauch', 'petersilie', 'kräuter', 'kümmel', 'kurkuma', 'basilikum', 'muskat', 'senf', 'zimt', 'oregano', 'thymian']],
  ['pancake', ['pfannkuchen', 'kaiserschmarrn', 'pancake', 'eierkuchen', 'crêpe', 'crepe']],
  ['bacon', ['schinken', 'speck', 'bacon']],
  ['steak', ['fleisch', 'steak', 'schnitzel', 'filet', 'hack', 'gulasch', 'braten']],
  ['burger', ['burger']],
  ['cheese', ['käse', 'mozzarella', 'emmentaler', 'gouda', 'feta', 'parmesan', 'halloumi', 'paneer']],
  ['mushroom', ['pilz', 'champignon']],
  ['lemon', ['zitrone', 'limette']],
  ['potatoe', ['kartoffel', 'potatoe', 'pommes', 'rösti']],
  ['pumpkin', ['kürbis']],
  ['rice', ['reis', 'risotto', 'biryani', 'paella']],
  ['soup', ['suppe', 'eintopf', 'brühe']],
  ['pizza', ['pizza']],
  ['egg', ['eier', 'ei', 'omelett', 'rührei', 'spiegelei']],
  ['pasta', ['pasta', 'nudel', 'spaghetti', 'spätzle', 'tagliatelle', 'penne', 'maultasche', 'gnocchi', 'tortellini']],
]

/** Liefert den Bildnamen (z. B. "pizza" oder Anfangsbuchstabe "k"). */
export function chooseImage(title, override) {
  if (override && meta[override]) return override
  const words = String(title).toLowerCase().split(/[\s,&/-]+/).filter(Boolean)
  for (const word of words) {
    for (const [image, keys] of RULES) {
      if (keys.some((k) => (k.length <= 2 ? word === k : word.includes(k)))) return image
    }
  }
  const first = (words[0] || '').normalize('NFD').replace(/[^a-z]/g, '')[0]
  return first && meta[first] ? first : 'a'
}

export function imageUrl(name, large = false) {
  const base = import.meta.env.BASE_URL
  if (large && meta[name]?.large) return `${base}img/food/${name}.large.webp`
  return `${base}img/food/${name}.webp`
}

export function hasLarge(name) {
  return !!meta[name]?.large
}

export function imageBg(name) {
  return meta[name]?.bg || '#92092f'
}
