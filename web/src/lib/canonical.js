// Einheitliche Zutaten: gleiche Sache = gleicher Name und eine Einheit für die Einkaufsliste.
//
// Jeder Eintrag: [Name, Basiseinheit, { Einheit: Faktor zur Basiseinheit }, [Schreibweisen]]
// Einheit '' bedeutet Stück. Gibt es für eine Einheit keinen Faktor, bleibt sie als eigene
// Zeile auf der Einkaufsliste stehen (nichts wird geraten).

const SPICE = { TL: 1, EL: 3, Prise: 1 / 16, g: 1 / 3, 'Pck.': 2 } // Gewürze in Teelöffeln
const LIQUID = { ml: 1, g: 1, EL: 15, TL: 5 }

const TABLE = [
  // ---- Gemüse & Obst ----
  ['Zwiebeln', '', { '': 1, g: 1 / 100 }, ['zwiebel', 'zwiebeln', 'kleine zwiebel, gewürfelt', 'zwiebeln (mittelgroß)', 'zwiebeln (weiß)']],
  ['rote Zwiebeln', '', { '': 1, g: 1 / 100 }, ['rote zwiebel', 'rote zwiebeln', 'zwiebel (rot)', 'zwiebel (rot, gewürfelt)']],
  ['Schalotten', '', { '': 1, g: 1 / 30 }, ['schalotten', 'schalotte']],
  ['Knoblauch', 'Zehe', { Zehe: 1, '': 1 }, ['knoblauch', 'knoblauchzehe', 'knoblauchzehen', 'knoblauch (gehackt)']],
  ['Frühlingszwiebeln', '', { '': 1, Stange: 1, Bund: 6 }, ['frühlingszwiebel', 'frühlingszwiebeln']],
  ['Porree', 'Stange', { Stange: 1, '': 1, g: 1 / 250 }, ['porree', 'lauch']],
  ['Karotten', '', { '': 1, g: 1 / 100 }, ['karotte', 'karotten', 'karotten in scheiben', 'möhren', 'möhre']],
  ['Zucchini', '', { '': 1, g: 1 / 250 }, ['zucchini']],
  ['Paprika, rot', '', { '': 1, g: 1 / 150 }, ['rote paprika', 'paprika (rot)', 'rote paprikaschoten']],
  ['Paprika, gelb', '', { '': 1, g: 1 / 150 }, ['gelbe paprikaschoten', 'gelbe paprika']],
  ['Paprika, grün', '', { '': 1, g: 1 / 150 }, ['grüne paprika', 'grüne paprikaschoten']],
  ['Paprika', '', { '': 1, g: 1 / 150 }, ['paprika']],
  ['Brokkoli', 'g', { g: 1, '': 400, Kopf: 400 }, ['brokkoli', 'brokkoliröschen', 'brokkoli (oder anderes gemüse nach wahl)']],
  ['Blumenkohl', 'g', { g: 1, '': 800, Kopf: 800 }, ['blumenkohl']],
  ['Champignons, braun', 'g', { g: 1, '': 20 }, ['braune champignons']],
  ['Champignons', 'g', { g: 1, '': 20 }, ['champignons', 'weiße champignons', 'pilze']],
  ['Hokkaido-Kürbis', 'g', { g: 1, '': 1000 }, ['hokkaido-kürbis', 'hokkaidokürbis', 'hokkaido-kürbis (geschält und gewürfelt)']],
  ['Kartoffeln, festkochend', 'g', { g: 1, '': 150 }, ['kartoffeln', 'kartoffeln, festkochend', 'festkochende kartoffeln', 'kartoffeln, vorwiegend festkochend', 'drillinge']],
  ['Kartoffeln, mehligkochend', 'g', { g: 1, '': 150 }, ['kartoffeln, mehligkochend', 'ofenkartoffeln']],
  ['Süßkartoffeln', 'g', { g: 1, '': 300 }, ['süßkartoffel', 'süßkartoffeln']],
  ['Tomaten', '', { '': 1, g: 1 / 100 }, ['tomaten', 'tomate', 'tomate (gewürfelt)', 'tomaten, gewürfelt']],
  ['Spinat', 'g', { g: 1 }, ['babyspinat', 'blattspinat']],
  ['Staudensellerie', 'Stange', { Stange: 1, g: 1 / 50 }, ['staudensellerie']],
  ['Ingwer', 'g', { g: 1, '': 30 }, ['ingwer', 'daumengroßes stück ingwer']],
  ['Limetten', '', { '': 1, g: 1 / 60 }, ['limette', 'limetten', 'limettenspalten (optional)']],
  ['Zitronen', '', { '': 1 }, ['zitrone', 'zitronen', 'zitrone (unbehandelt)', 'zitronen, unbehandelt']],
  ['Chilischoten', '', { '': 1, g: 1 / 15 }, ['chilischote', 'rote chilischoten', 'milde chilischoten']],
  ['Mais', 'g', { g: 1, Dose: 285 }, ['mais', 'mais (dose)', 'mais (dose oder tk)', 'maiskörner']],
  ['Erbsen (TK)', 'g', { g: 1 }, ['erbsen', 'erbsen (tk)', 'erbsen (tiefgefroren)']],
  ['Grüne Bohnen', 'g', { g: 1 }, ['grüne bohnen', 'buschbohnen']],
  ['Petersilie', 'Bund', { Bund: 1, g: 1 / 20, Stange: 1 / 10, '': 1 / 10, EL: 1 / 4, TL: 1 / 12 }, ['petersilie', 'petersilie, gehackt']],
  ['Koriander', 'Bund', { Bund: 1, g: 1 / 20, EL: 1 / 4, TL: 1 / 12 }, ['koriander', 'koriander, frisch', 'koriander, frisch, gehackt', 'koriander, gehackt']],
  ['Basilikum', 'Bund', { Bund: 1, '': 1 / 15, EL: 1 / 4 }, ['basilikum', 'basilikum, frisch', 'basilikumblätter']],
  ['Schnittlauch', 'Bund', { Bund: 1, '': 1 }, ['schnittlauch']],

  // ---- Milch, Käse & Kühlregal ----
  ['Sahne', 'g', LIQUID, ['sahne', 'kochsahne', 'kochsahne (leicht)', 'schlagsahne']],
  ['Milch', 'ml', LIQUID, ['milch', 'milch (1,5 %)', 'milch (oder pflanzendrink)']],
  ['Crème fraîche', 'g', { g: 1, Becher: 200, EL: 15 }, ['crème fraîche', 'creme fraiche']],
  ['Saure Sahne', 'g', { g: 1, Becher: 200, EL: 15 }, ['saure sahne']],
  ['Naturjoghurt', 'g', { g: 1, EL: 15 }, ['joghurt', 'naturjoghurt', 'sahnejoghurt']],
  ['Butter', 'g', { g: 1, EL: 15, TL: 5 }, ['butter']],
  ['Eier', '', { '': 1 }, ['ei', 'eier', 'eier (größe l)']],
  ['Frischkäse', 'g', { g: 1, EL: 20 }, ['frischkäse', 'frischkäse natur (3 % fett)']],
  ['Parmesan', 'g', { g: 1 }, ['parmesan', 'parmesan am stück', 'parmesan, gerieben', 'parmesan (frisch gerieben)', 'geriebener parmesan', 'hartkäse (gerieben)', 'hartkäse (ital. art, gerieben)']],
  ['Gouda', 'g', { g: 1 }, ['gouda (gerieben)', 'gouda am stück', 'würziger reibekäse']],
  ['Cheddar', 'g', { g: 1 }, ['cheddar', 'cheddar (gerieben)', 'cheddar am stück']],
  ['Mozzarella', 'g', { g: 1 }, ['mozzarella', 'mozzarella, gerieben']],
  ['Feta', 'g', { g: 1 }, ['feta', 'schafskäse', 'hirtenkäse']],
  ['Halloumi', 'g', { g: 1, 'Pck.': 225 }, ['halloumi', 'grillkäse']],
  ['Gnocchi', 'g', { g: 1 }, ['gnocchi', 'gnocchi (kühlregal)', 'frische gnocchi']],

  // ---- Fleisch & Fisch ----
  ['Hähnchenbrust', 'g', { g: 1, 'Pck.': 300, '': 160 }, ['hähnchen', 'hähnchenbrust', 'hähnchenbrustfilet', 'hähnchenbrustfilets', 'hähnchenbrustfilets (à 160 g)', 'hähnchengeschnetzeltes', 'hähncheninnenbrustfilet', 'hähnchenschnitzel', 'hähnchenfleisch']],
  ['Putenbrust', 'g', { g: 1 }, ['putenbrustfilets', 'putenschnitzel', 'putengeschnetzeltes']],
  ['Hackfleisch, gemischt', 'g', { g: 1 }, ['hackfleisch', 'gemischtes hackfleisch']],
  ['Bacon', 'g', { g: 1, Scheibe: 15 }, ['bacon', 'bacon (streifen)', 'frühstücksspeck']],
  ['Speckwürfel', 'g', { g: 1 }, ['speckwürfel', 'räucherspeck, gewürfelt']],
  ['Kochschinken', 'g', { g: 1, Scheibe: 20 }, ['kochschinken', 'kochschinken am stück']],

  // ---- Nudeln, Reis & Konserven ----
  ['Basmatireis', 'g', { g: 1 }, ['basmatireis', 'reis', 'langkornreis', 'parboiled reis']],
  ['Penne', 'g', { g: 1 }, ['penne', 'penne rigate']],
  ['Stückige Tomaten', 'g', { g: 1, ml: 1, Dose: 400 }, ['stückige tomaten', 'stückige tomaten (dose)', 'stückige tomaten (2 dosen)', 'gehackte tomaten', 'tomaten (gehackt)', 'tomaten (dose)']],
  ['Passierte Tomaten', 'g', { g: 1, ml: 1, Dose: 500 }, ['passierte tomaten']],
  ['Tomatenmark', 'g', { g: 1, EL: 15, TL: 5 }, ['tomatenmark']],
  ['Kokosmilch', 'ml', { ml: 1, g: 1, EL: 15, Dose: 400 }, ['kokosmilch']],
  ['Kidneybohnen', 'g', { g: 1, Dose: 400 }, ['kidneybohnen', 'kidneybohnen (dose)', 'kidneybohnen (2 dosen)']],
  ['Tortillas', '', { '': 1, 'Pck.': 8 }, ['tortillas', 'tortillas (groß)', 'tortillas (klein)', 'weizentortillas']],

  // ---- Gewürze, Öl & Soßen ----
  ['Gemüsebrühe', 'g', { g: 1, TL: 5, EL: 15, 'Pck.': 8, ml: 1 / 50 }, ['gemüsebrühe', 'gemüsebrühpulver']],
  ['Rinderbrühe', 'g', { g: 1, TL: 5, ml: 1 / 50 }, ['rinderbrühe']],
  ['Gemüse-Gewürzpaste', 'g', { g: 1, TL: 5, EL: 15 }, ['gemüse-gewürzpaste']],
  ['Hühnerbrühe', 'g', { g: 1, TL: 5, ml: 1 / 50 }, ['hühnerbrühe', 'geflügelbrühe']],
  ['Olivenöl', 'ml', { ml: 1, g: 1, EL: 10, TL: 5 }, ['olivenöl']],
  ['Pflanzenöl', 'ml', { ml: 1, g: 1, EL: 10, TL: 5 }, ['öl', 'pflanzenöl', 'rapsöl', 'rapsöl zum ausbacken', 'öl zum braten']],
  ['Sesamöl', 'ml', { ml: 1, g: 1, EL: 10, TL: 5 }, ['sesamöl']],
  ['Sojasoße', 'ml', { ml: 1, g: 1, EL: 15, TL: 5 }, ['sojasoße', 'sojasauce', 'sojasauce, dunkel']],
  ['Senf, mittelscharf', 'g', { g: 1, ml: 1, TL: 5, EL: 15 }, ['senf', 'senf, mittelscharf', 'mittelscharfer senf']],
  ['Zitronensaft', 'ml', { ml: 1, EL: 15, TL: 5, '': 30 }, ['zitronensaft']],
  ['Tom-Ka-Paste', 'g', { g: 1, EL: 15 }, ['tom-ka-paste', 'tom ka paste']],
  ['Rote Currypaste', 'g', { g: 1, TL: 5, EL: 15 }, ['rote currypaste']],
  ['Grüne Currypaste', 'g', { g: 1, TL: 5, EL: 15 }, ['grüne currypaste']],
  ['Madras-Currypulver', 'TL', SPICE, ['madras-currypulver', 'madras-curry-pulver']],
  ['Currypulver', 'TL', SPICE, ['currypulver', 'currypulver, mild']],
  ['Paprikapulver, edelsüß', 'TL', SPICE, ['paprikapulver', 'paprikapulver, edelsüß', 'paprikapulver (edelsüß)', 'paprikapulver (edelsüß/geräuchert)']],
  ['Paprikapulver, geräuchert', 'TL', SPICE, ['paprikapulver, geräuchert', 'geräuchertes paprikapulver']],
  ['Paprikapulver, rosenscharf', 'TL', SPICE, ['paprikapulver, rosenscharf']],
  ['Kreuzkümmel, gemahlen', 'TL', SPICE, ['kreuzkümmel', 'kreuzkümmel, gemahlen', 'kreuzkümmel (gemahlen)', 'kreuzkümmelpulver']],
  ['Oregano, getrocknet', 'TL', SPICE, ['oregano, getrocknet', 'oregano, gerebelt']],
  ['Italienische Kräuter', 'TL', SPICE, ['italienische kräuter, getrocknet', 'getrocknete kräuter']],
  ['Kräuter der Provence', 'TL', SPICE, ['kräuter der provence']],
  ['Knoblauchpulver', 'TL', SPICE, ['knoblauchpulver']],
  ['Zwiebelpulver', 'TL', SPICE, ['zwiebelpulver']],
  ['Chiliflocken', 'TL', SPICE, ['chiliflocken']],
  ['Muskat', 'TL', SPICE, ['muskat']],
  ['Zimt', 'TL', SPICE, ['zimt']],
  ['Kurkuma', 'TL', SPICE, ['kurkuma']],
  ['Garam Masala', 'TL', SPICE, ['garam masala']],
  ['Salz', 'TL', SPICE, ['salz']],
  ['Pfeffer', 'TL', SPICE, ['pfeffer']],

  // ---- Backen & Nüsse ----
  ['Mehl', 'g', { g: 1, EL: 10, TL: 3 }, ['mehl']],
  ['Zucker', 'g', { g: 1, EL: 12, TL: 4, Prise: 0.5 }, ['zucker']],
  ['Speisestärke', 'g', { g: 1, TL: 3, EL: 9 }, ['speisestärke', 'stärke', 'maisstärke']],
  ['Honig', 'g', { g: 1, TL: 7, EL: 20 }, ['honig']],
  ['Erdnussbutter', 'g', { g: 1, 'Pck.': 30, EL: 15 }, ['erdnussbutter', 'erdnussbutter, crunchy', 'erdnussbutter, smooth']],
  ['Erdnüsse, gesalzen', 'g', { g: 1 }, ['gesalzene erdnüsse', 'erdnüsse, geröstet, gesalzen']],
  ['Cashewkerne', 'g', { g: 1 }, ['cashewkerne', 'cashewkerne, geröstet', 'geröstete cashewkerne']],
  ['Kürbiskerne', 'g', { g: 1 }, ['kürbiskerne']],
]

const BY_ALIAS = new Map()
for (const [name, base, conv, aliases] of TABLE) {
  for (const a of [name.toLowerCase(), ...aliases]) BY_ALIAS.set(a, { name, base, conv })
}

/** Einheitlicher Name für eine Zutat (oder der Name unverändert, wenn unbekannt). */
export function canonicalName(name) {
  return BY_ALIAS.get(String(name).toLowerCase().trim())?.name ?? String(name).trim()
}

/**
 * Wandelt eine Zutat in Name + Basiseinheit um, damit sie mit anderen zusammengezählt
 * werden kann. Unbekannte Einheiten bleiben unverändert.
 * @param {{amount:number|null, unit:string, name:string}} ing
 */
export function canonicalize(ing) {
  const entry = BY_ALIAS.get(String(ing.name).toLowerCase().trim())
  if (!entry) return ing
  const out = { ...ing, name: entry.name }
  if (ing.amount == null) return { ...out, unit: entry.base }
  const factor = entry.conv[ing.unit ?? '']
  if (factor == null) return out
  return { ...out, amount: ing.amount * factor, unit: entry.base }
}

// Einzahl für Stückzutaten ("1 Zwiebel", aber "2 Zwiebeln")
const SINGULAR = {
  Zwiebeln: 'Zwiebel',
  'rote Zwiebeln': 'rote Zwiebel',
  Schalotten: 'Schalotte',
  Frühlingszwiebeln: 'Frühlingszwiebel',
  Karotten: 'Karotte',
  Tomaten: 'Tomate',
  Limetten: 'Limette',
  Zitronen: 'Zitrone',
  Chilischoten: 'Chilischote',
  Eier: 'Ei',
  Tortillas: 'Tortilla',
}

/** Anzeigename passend zur Menge. */
export function displayName(name, amount, unit) {
  if ((unit ?? '') === '' && amount != null && amount <= 1 && SINGULAR[name]) return SINGULAR[name]
  return name
}
