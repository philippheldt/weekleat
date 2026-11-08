// Ordnet Einkaufsartikel den Bereichen im Supermarkt zu – in der Reihenfolge,
// in der man durch einen typischen Discounter (z. B. Lidl) läuft.

export const AISLES = [
  { id: 'obst', label: 'Obst & Gemüse' },
  { id: 'brot', label: 'Brot & Backwaren' },
  { id: 'kuehl', label: 'Milch, Käse & Kühlregal' },
  { id: 'fleisch', label: 'Fleisch, Wurst & Fisch' },
  { id: 'trocken', label: 'Nudeln, Reis & Konserven' },
  { id: 'gewuerze', label: 'Gewürze, Öl & Soßen' },
  { id: 'backen', label: 'Backen, Frühstück & Nüsse' },
  { id: 'getraenke', label: 'Getränke' },
  { id: 'tk', label: 'Tiefkühl' },
  { id: 'drogerie', label: 'Drogerie & Haushalt' },
  { id: 'sonstiges', label: 'Sonstiges' },
]

// Reihenfolge der Regeln ist wichtig: spezielle Begriffe zuerst
// ("Kürbiskernöl" ist Öl, nicht Kürbis; "Erbsen (TK)" ist Tiefkühl, nicht Gemüse).
const RULES = [
  ['tk', ['(tk)', 'tiefkühl', 'tk-', 'eiscreme', 'speiseeis', 'pommes frites']],
  ['drogerie', ['klopapier', 'toilettenpapier', 'küchenrolle', 'taschentücher', 'spülmittel', 'waschmittel', 'spülmaschine', 'zahnpasta', 'zahnbürste', 'shampoo', 'duschgel', 'seife', 'müllbeutel', 'deo', 'windeln', 'feuchttücher', 'alufolie', 'backpapier', 'frischhaltefolie', 'schwamm', 'putzmittel', 'reiniger']],
  // Ausnahmen, die sonst in einem anderen Bereich landen würden
  ['obst', ['kartoffel', 'zuckerschoten']],
  ['trocken', ['kokosmilch', 'stückige tomaten', 'passierte tomaten', 'gehackte tomaten', 'getrocknete tomaten', 'tomatenmark', '(dose', 'dosen)', 'apfelmus']],
  ['gewuerze', ['zitronensaft', 'essig', 'öl', 'butterschmalz']],
  ['backen', ['erdnüsse', 'erdnussbutter', 'cashew', 'kürbiskerne', 'getrocknete aprikosen', 'kokosraspeln', 'paniermehl', 'semmelbrösel']],
  ['getraenke', ['wein', 'rotwein', 'weißwein', 'saft', 'mineralwasser', 'sprudel', 'bier', 'metaxa', 'cola', 'limo', 'schorle', 'kaffee', 'tee']],
  ['gewuerze', ['salz', 'pfeffer', 'pulver', 'gewürz', 'getrocknet', 'gerebelt', 'gemahlen', 'kräuter der provence', 'italienische kräuter', 'kümmel', 'kardamom', 'kurkuma', 'muskat', 'zimt', 'nelken', 'lorbeer', 'wacholder', 'chiliflocken', 'garam masala', 'paste', 'brühe', 'fond', 'senf', 'ketchup', 'sojasauce', 'sojasoße', 'worcester', 'tabasco', 'chili-soße', 'pesto', 'ajvar', 'chutney', 'mayonnaise', 'pommes-sauce', 'kapern']],
  ['backen', ['mehl', 'zucker', 'honig', 'haferflocken', 'cornflakes', 'müsli', 'nüsse', 'nusskerne', 'mandel', 'walnuss', 'pinienkerne', 'sesam', 'rosinen', 'stärke', 'hefe', 'backpulver', 'schokolade', 'marmelade', 'nutella']],
  ['brot', ['brot', 'brötchen', 'buns', 'tortilla', 'wraps', 'naan', 'toast', 'baguette', 'croissant', 'pita']],
  ['fleisch', ['hähnchen', 'huhn', 'hühnchen', 'pute', 'rind', 'schwein', 'hackfleisch', 'speck', 'bacon', 'schinken', 'kalb', 'gulasch', 'wurst', 'würstchen', 'salami', 'lamm', 'kabeljau', 'lachs', 'fisch', 'garnelen', 'filet', 'schnitzel', 'geschnetzeltes']],
  ['kuehl', ['kühlregal', 'milch', 'sahne', 'joghurt', 'quark', 'schmand', 'crème fraîche', 'creme fraiche', 'frischecreme', 'butter', 'ei', 'eier', 'eigelb', 'käse', 'mozzarella', 'parmesan', 'gouda', 'emmentaler', 'feta', 'gorgonzola', 'cheddar', 'halloumi', 'tofu', 'gnocchi', 'spätzle', 'tortellini', 'klöße', 'teig']],
  ['trocken', ['nudel', 'penne', 'fusilli', 'rigatoni', 'spaghetti', 'tagliatelle', 'lasagne', 'orzo', 'couscous', 'reis', 'linsen', 'kichererbsen', 'kidneybohnen', 'sojaschnetzel', 'bulgur', 'quinoa', 'oliven']],
  ['obst', ['zwiebel', 'knoblauch', 'karotte', 'möhre', 'paprika', 'tomate', 'gurke', 'zucchini', 'brokkoli', 'blumenkohl', 'spinat', 'salat', 'rucola', 'kohlrabi', 'lauch', 'porree', 'sellerie', 'pilz', 'champignon', 'pfifferling', 'portobello', 'kürbis', 'kartoffel', 'drilling', 'pastinake', 'spargel', 'bohnen', 'zuckerschoten', 'erbsen', 'radieschen', 'ingwer', 'chili', 'limette', 'zitrone', 'orange', 'apfel', 'äpfel', 'birne', 'kiwi', 'avocado', 'pfirsich', 'banane', 'beeren', 'trauben', 'petersilie', 'schnittlauch', 'basilikum', 'koriander', 'minze', 'thymian', 'rosmarin', 'salbei', 'majoran', 'dill', 'kräuter', 'wirsing', 'kohl', 'mais', 'schalotte', 'gemüse', 'obst', 'aubergine', 'fenchel', 'rote bete']],
]

// Diese Begriffe zählen nur als ganzes Wort ("cola" nicht in "Rucola", "wein" nicht in "Schwein")
const WHOLE_WORD = new Set(['ei', 'eier', 'tee', 'deo', 'cola', 'wein', 'limo', 'bier'])
const RE_CACHE = new Map()
function matches(name, key) {
  if (!WHOLE_WORD.has(key)) return name.includes(key)
  let re = RE_CACHE.get(key)
  if (!re) RE_CACHE.set(key, (re = new RegExp(`(^|[^a-zäöüß])${key}($|[^a-zäöüß])`)))
  return re.test(name)
}

/** @returns {string} id des Bereichs, z. B. "obst" */
export function aisleOf(name) {
  const n = ' ' + String(name).toLowerCase().trim() + ' '
  for (const [aisle, keys] of RULES) if (keys.some((k) => matches(n, k))) return aisle
  return 'sonstiges'
}

/** Gruppiert Artikel nach Bereich in Ladenreihenfolge (leere Bereiche entfallen). */
export function groupByAisle(items) {
  const groups = new Map(AISLES.map((a) => [a.id, []]))
  for (const item of items) groups.get(aisleOf(item.name)).push(item)
  return AISLES.map((a) => ({ ...a, items: groups.get(a.id) })).filter((g) => g.items.length)
}
