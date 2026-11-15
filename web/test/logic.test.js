import { describe, it, expect } from 'vitest'
import fs from 'node:fs'
import { parseIngredient, formatAmount, aggregate } from '../src/lib/ingredients.js'
import { parseCatalog } from '../src/lib/catalog.js'
import { generatePlan, DEFAULT_SETTINGS, implicitVote, scores } from '../src/lib/generator.js'
import { buildAutoItems, diffShopping, pantryMatcher } from '../src/lib/shopping.js'
import { upcomingWeek } from '../src/lib/week.js'

function seeded(seed) {
  return () => ((seed = (seed * 16807) % 2147483647) - 1) / 2147483646
}

describe('Zutaten', () => {
  it.each([
    ['375g Kartoffeln', 375, 'g', 'Kartoffeln'],
    ['1 EL Öl', 1, 'EL', 'Öl'],
    ['1EL Öl', 1, 'EL', 'Öl'],
    ['1,5 kg Mehl', 1500, 'g', 'Mehl'],
    ['½ Bund Petersilie', 0.5, 'Bund', 'Petersilie'],
    ['1/2 Zitrone', 0.5, '', 'Zitrone'],
    ['2-3 Zwiebeln', 3, '', 'Zwiebeln'],
    ['2 Zehen Knoblauch', 2, 'Zehe', 'Knoblauch'],
    ['Salz', null, '', 'Salz'],
    ['1 l Gemüsebrühe', 1000, 'ml', 'Gemüsebrühe'],
  ])('%s', (text, amount, unit, name) => {
    expect(parseIngredient(text)).toEqual({ amount, unit, name })
  })
  it('Objektform', () => {
    expect(parseIngredient({ menge: 2, einheit: 'kg', name: 'Mehl' })).toEqual({ amount: 2000, unit: 'g', name: 'Mehl' })
  })
  it('formatiert', () => {
    expect(formatAmount(1500, 'g')).toBe('1,5 kg')
    expect(formatAmount(333.3, 'g')).toBe('330 g')
    expect(formatAmount(2, 'Zehe')).toBe('2 Zehen')
    expect(formatAmount(1.5, '')).toBe('1½')
    expect(formatAmount(1.1, '')).toBe('1¼')
    expect(formatAmount(null, '')).toBe('')
  })
  it('fasst zusammen', () => {
    const r = aggregate([
      { amount: 1, unit: '', name: 'Zwiebel' },
      { amount: 2, unit: '', name: 'Zwiebeln' },
      { amount: 100, unit: 'g', name: 'Käse' },
      { amount: 1, unit: 'Pck.', name: 'Käse' },
    ])
    expect(r).toHaveLength(3)
    expect(r[0].amount).toBe(3)
  })
})

const catalogText = fs.readFileSync(new URL('./fixtures/beispiel.yaml', import.meta.url), 'utf8')
const realCatalog = fs.readFileSync(new URL('../public/rezepte.yaml', import.meta.url), 'utf8')

describe('Katalog', () => {
  it('eure rezepte.yaml ist fehlerfrei', () => {
    const { recipes, problems } = parseCatalog(realCatalog)
    expect(problems).toEqual([])
    expect(recipes.length).toBeGreaterThan(0)
    for (const r of recipes) expect(r.ingredients.every((i) => i.name)).toBe(true)
  })
  it('planen: nein wird nie automatisch eingeplant', () => {
    const { recipes } = parseCatalog(
      'rezepte:\n  - titel: Soße\n    planen: nein\n    zutaten: [1 Ei]\n  - titel: Essen\n    zutaten: [1 Ei]\n',
    )
    expect(recipes.map((r) => r.plannable)).toEqual([false, true])
    const empty = Array.from({ length: 7 }, () => ({ recipeId: null, locked: false }))
    const { plan } = generatePlan({ recipes, settings: DEFAULT_SETTINGS, plan: empty, week: '2026-11-09' })
    expect(plan.every((d) => d.recipeId === 'essen')).toBe(true)
  })
  it('Saison: Monate werden gelesen, außerhalb wird nicht eingeplant', () => {
    const { recipes } = parseCatalog(
      'rezepte:\n  - titel: Kürbis\n    saison: [sep, okt, nov]\n    zutaten: [1 Ei]\n  - titel: Immer\n    zutaten: [1 Ei]\n  - titel: Alle\n    saison: [1,2,3,4,5,6,7,8,9,10,11,12]\n    zutaten: [1 Ei]\n',
    )
    expect(recipes.map((r) => r.months)).toEqual([[9, 10, 11], [], []])
    const empty = Array.from({ length: 7 }, () => ({ recipeId: null, locked: false }))
    const ids = (week) =>
      generatePlan({ recipes: recipes.slice(0, 2), settings: { ...DEFAULT_SETTINGS, noRepeatWeeks: 0 }, plan: empty, week }).plan.map((d) => d.recipeId)
    expect(ids('2026-10-12')).toContain('kuerbis')
    // im Juni außer Saison: wird nur genommen, wenn sonst gar nichts geht (Lockerung), aber nicht vorrangig
    const june = generatePlan({ recipes: recipes.slice(0, 2), settings: DEFAULT_SETTINGS, plan: [{ recipeId: null }, ...Array(6).fill({ recipeId: null, locked: true })], week: '2026-06-08' }).plan
    expect(june[0].recipeId).toBe('immer')
  })

  it('Quelle: Text, sonst Domain des Links', () => {
    const { recipes } = parseCatalog(
      'rezepte:\n  - titel: A\n    quelle: HelloFresh\n    zutaten: [1 Ei]\n  - titel: B\n    link: https://www.chefkoch.de/rezepte/1\n    zutaten: [1 Ei]\n  - titel: C\n    zutaten: [1 Ei]\n',
    )
    expect(recipes.map((r) => r.source)).toEqual(['HelloFresh', 'chefkoch.de', ''])
  })
  it('liest die Beispieldatei ohne Probleme', () => {
    const { recipes, problems } = parseCatalog(catalogText)
    expect(problems).toEqual([])
    expect(recipes.length).toBeGreaterThan(10)
    const pizza = recipes.find((r) => r.id === 'pizza-margherita')
    expect(pizza.days).toEqual(['fr', 'sa', 'so'])
    expect(pizza.image).toBe('pizza')
  })
  it('meldet Fehler verständlich', () => {
    const { recipes, problems } = parseCatalog('rezepte:\n  - titel: A\n    kategorie: suppe\n    zutaten: [1 Ei]\n  - zutaten: [x]\n  - titel: A\n    zutaten: [y]\n')
    expect(recipes).toHaveLength(2)
    expect(problems.join('\n')).toMatch(/suppe/)
    expect(problems.join('\n')).toMatch(/titel/)
    expect(problems.join('\n')).toMatch(/doppelt/)
  })
  it('errät Ernährung und Kategorie', () => {
    const { recipes } = parseCatalog('rezepte:\n  - titel: Spaghetti Carbonara\n    zutaten: [200 g Speck, 2 Eier]\n  - titel: Gemüsepfanne\n    zutaten: [1 Paprika]\n')
    expect(recipes[0]).toMatchObject({ category: 'nudeln', diet: 'fleisch' })
    expect(recipes[1]).toMatchObject({ category: 'sonstiges', diet: 'vegan' })
  })
})

describe('Generator', () => {
  const { recipes } = parseCatalog(catalogText)
  const empty = Array.from({ length: 7 }, () => ({ recipeId: null, locked: false }))
  const byId = Object.fromEntries(recipes.map((r) => [r.id, r]))

  it('plant 7 verschiedene Rezepte', () => {
    for (let s = 1; s < 50; s++) {
      const { plan } = generatePlan({ recipes, settings: DEFAULT_SETTINGS, plan: empty, week: '2026-11-09', random: seeded(s) })
      const ids = plan.map((d) => d.recipeId)
      expect(ids.every(Boolean)).toBe(true)
      expect(new Set(ids).size).toBe(7)
      // "selten" Fleisch = 1 Fleisch-/Fischgericht
      expect(ids.filter((id) => ['fleisch', 'fisch'].includes(byId[id].diet))).toHaveLength(1)
      // Pizza/Flammkuchen nur Fr–So
      ids.forEach((id, i) => {
        if (byId[id].days.length) expect(i).toBeGreaterThanOrEqual(4)
      })
    }
  })

  it('lässt gesperrte Tage stehen und plant nur aktive Tage', () => {
    const plan = [...empty]
    plan[2] = { recipeId: 'kaesespaetzle', locked: true }
    const settings = { ...DEFAULT_SETTINGS, days: [true, true, true, true, true, false, false] }
    const r = generatePlan({ recipes, settings, plan, week: '2026-11-09', random: seeded(3) })
    expect(r.plan[2]).toEqual({ recipeId: 'kaesespaetzle', locked: true })
    expect(r.plan[5].recipeId).toBeNull()
    expect(r.plan[6].recipeId).toBeNull()
    expect(r.plan.slice(0, 5).every((d) => d.recipeId)).toBe(true)
  })

  it('respektiert vegetarisch / vegan', () => {
    for (const diet of ['vegetarisch', 'vegan']) {
      const r = generatePlan({ recipes, settings: { ...DEFAULT_SETTINGS, diet }, plan: empty, week: '2026-11-09', random: seeded(7) })
      for (const d of r.plan) if (d.recipeId) expect(diet === 'vegan' ? ['vegan'] : ['vegan', 'vegetarisch']).toContain(byId[d.recipeId].diet)
    }
  })

  it('Upvotes erhöhen, Downvotes senken die Chance', () => {
    const count = (votes) => {
      let n = 0
      for (let s = 1; s < 300; s++) {
        const { plan } = generatePlan({ recipes, settings: DEFAULT_SETTINGS, plan: empty, votes, week: '2026-11-09', random: seeded(s) })
        if (plan.some((d) => d.recipeId === 'linsen-dal')) n++
      }
      return n
    }
    const neutral = count([])
    const up = count([{ recipeId: 'linsen-dal', value: 1 }, { recipeId: 'linsen-dal', value: 1 }, { recipeId: 'linsen-dal', value: 1 }])
    const down = count([{ recipeId: 'linsen-dal', value: -1 }, { recipeId: 'linsen-dal', value: -1 }, { recipeId: 'linsen-dal', value: -1 }])
    expect(up).toBeGreaterThan(neutral)
    expect(down).toBeLessThan(neutral)
  })

  it('automatische Stimmen: würfeln −1, auswählen +1, je einmal pro Woche', () => {
    const a = implicitVote('2026-11-09', 'x', 'reroll')
    const b = implicitVote('2026-11-09', 'x', 'reroll')
    const c = implicitVote('2026-11-09', 'y', 'pick')
    expect(a.id).toBe(b.id) // gleiche id → überschreibt sich, zählt nur einmal
    expect(a.id).not.toBe('2026-11-09:x') // kollidiert nicht mit dem Knopf
    const byId = Object.fromEntries([a, b, c, { id: '2026-11-09:x', recipeId: 'x', value: 1 }].map((v) => [v.id, v]))
    expect(scores(Object.values(byId))).toEqual({ x: 0, y: 1 })
  })

  it('vermeidet Rezepte der letzten Wochen', () => {
    const history = recipes.slice(0, 6).map((r) => ({ recipeId: r.id, week: '2026-11-02' }))
    const { plan } = generatePlan({ recipes, settings: DEFAULT_SETTINGS, plan: empty, history, week: '2026-11-09', random: seeded(11) })
    for (const d of plan) expect(history.map((h) => h.recipeId)).not.toContain(d.recipeId)
  })

  it('würfelt einen einzelnen Tag neu', () => {
    const first = generatePlan({ recipes, settings: DEFAULT_SETTINGS, plan: empty, week: '2026-11-09', random: seeded(5) }).plan
    const r = generatePlan({ recipes, settings: DEFAULT_SETTINGS, plan: first, week: '2026-11-09', onlyDay: 3, random: seeded(9) })
    expect(r.plan[3].recipeId).not.toBe(first[3].recipeId)
    expect(new Set(r.plan.map((d) => d.recipeId)).size).toBe(7)
    r.plan.forEach((d, i) => i !== 3 && expect(d.recipeId).toBe(first[i].recipeId))
  })

  it('kommt mit wenigen Rezepten klar', () => {
    const few = recipes.slice(0, 3)
    const r = generatePlan({ recipes: few, settings: DEFAULT_SETTINGS, plan: empty, week: '2026-11-09', random: seeded(1) })
    expect(r.plan.every((d) => d.recipeId)).toBe(true)
    expect(r.warnings.length).toBe(1)
  })
})

describe('Einkaufsliste', () => {
  const { recipes } = parseCatalog(catalogText)
  it('rechnet Portionen um, fasst zusammen, lässt Vorrat weg', () => {
    const plan = Array.from({ length: 7 }, () => ({ recipeId: null, locked: false }))
    plan[0] = { recipeId: 'kartoffelsuppe' }
    plan[1] = { recipeId: 'kartoffelpuffer-mit-apfelmus' }
    const items = buildAutoItems(plan, recipes, { ...DEFAULT_SETTINGS, portions: 2 })
    const kart = items.find((i) => i.name === 'Kartoffeln, festkochend')
    expect(kart.amount).toBe(875) // (750 + 1000) / 2
    expect(kart.recipes).toHaveLength(2)
    expect(items.find((i) => i.name === 'Salz')).toBeUndefined()
    expect(items.find((i) => i.name === 'Zwiebeln').amount).toBe(1)
  })
  it('behält Häkchen und eigene Einträge', () => {
    const existing = [
      { id: 'auto:kartoffel|g', name: 'Kartoffeln', amount: 750, unit: 'g', checked: true, recipes: ['x'] },
      { id: 'auto:alt|', name: 'Alt', amount: 1, unit: '', checked: false },
      { id: 'm1', name: 'Milch', manual: true },
    ]
    const { upserts, deletes } = diffShopping(existing, [{ id: 'auto:kartoffel|g', name: 'Kartoffeln', amount: 800, unit: 'g', recipes: ['x'] }])
    expect(upserts[0].checked).toBe(true)
    expect(deletes).toEqual(['auto:alt|'])
  })
})

describe('Einheitliche Zutaten', () => {
  it('fasst Schreibweisen und Einheiten zusammen', () => {
    const r = aggregate([
      { amount: 200, unit: 'g', name: 'Sahne' },
      { amount: 150, unit: 'ml', name: 'Kochsahne' },
      { amount: 100, unit: 'ml', name: 'Schlagsahne' },
      { amount: 2, unit: '', name: 'Zwiebel' },
      { amount: 100, unit: 'g', name: 'Zwiebeln' },
      { amount: 1, unit: 'Dose', name: 'stückige Tomaten' },
      { amount: 400, unit: 'g', name: 'stückige Tomaten (Dose)' },
      { amount: 2, unit: 'EL', name: 'Tomatenmark' },
      { amount: 20, unit: 'g', name: 'Tomatenmark' },
      { amount: null, unit: '', name: 'Salz' },
      { amount: 1, unit: 'TL', name: 'Salz' },
    ])
    const by = Object.fromEntries(r.map((x) => [x.name, x]))
    expect(by['Sahne']).toMatchObject({ amount: 450, unit: 'g' })
    expect(by['Zwiebeln']).toMatchObject({ amount: 3, unit: '' })
    expect(by['Stückige Tomaten']).toMatchObject({ amount: 800, unit: 'g' })
    expect(by['Tomatenmark']).toMatchObject({ amount: 50, unit: 'g' })
    expect(r.filter((x) => x.name === 'Salz')).toHaveLength(1)
  })

  it('jede Zutat einer Art landet in genau einer Zeile', () => {
    const { recipes } = parseCatalog(realCatalog)
    const all = recipes.flatMap((r) => r.ingredients.filter((i) => i.amount != null))
    const items = aggregate(all)
    const names = items.map((i) => i.name)
    const dupes = names.filter((n, i) => names.indexOf(n) !== i)
    // erlaubt nur, wenn eine Einheit bewusst nicht umgerechnet wird
    expect(dupes).toEqual([])
  })
})

describe('Vorrat', () => {
  it('erkennt Zutaten unabhängig von Schreibweise', () => {
    const has = pantryMatcher({ pantry: 'Paprikapulver\nsenf; Öl, Salz, Kreuzkümmel, Chiliflocken' })
    for (const n of ['Paprikapulver, edelsüß', 'Paprikapulver, geräuchert', 'geräuchertes Paprikapulver', 'Senf, mittelscharf', 'süßer Senf', 'körniger Senf', 'Öl', 'Pflanzenöl', 'Rapsöl', 'Rapsöl zum Ausbacken', 'Salz', 'Kreuzkümmel (Ganz)', 'Kreuzkümmelpulver'])
      expect(has(n), n).toBe(true)
    for (const n of ['Olivenöl', 'Sesamöl', 'Paprika', 'Pfeffer', 'Chilipulver', 'gehackter Knoblauch & Ingwer in Öl'])
      expect(has(n), n).toBe(false)
  })
  it('mit Sorte nur diese Sorte', () => {
    const has = pantryMatcher({ pantry: 'Paprikapulver edelsüß' })
    expect(has('Paprikapulver, edelsüß')).toBe(true)
    expect(has('Paprikapulver (edelsüß)')).toBe(true)
    expect(has('Paprikapulver, rosenscharf')).toBe(false)
  })
})

describe('Bestehende Einkaufsliste', () => {
  it('Häkchen bleiben erhalten, wenn alte Zeilen zusammengefasst werden', () => {
    const existing = [
      { id: 'auto:kochsahne|g', name: 'Kochsahne', amount: 200, unit: 'g', checked: true },
      { id: 'auto:sahne|ml', name: 'Sahne', amount: 100, unit: 'ml', checked: true },
      { id: 'auto:zwiebel|', name: 'Zwiebel', amount: 1, unit: '', checked: true },
      { id: 'auto:zwiebel|g', name: 'Zwiebeln', amount: 100, unit: 'g', checked: false },
      { id: 'm:1', name: 'Milch', manual: true, checked: true },
    ]
    const auto = aggregate([
      { amount: 200, unit: 'g', name: 'Kochsahne' },
      { amount: 100, unit: 'ml', name: 'Sahne' },
      { amount: 1, unit: '', name: 'Zwiebel' },
      { amount: 100, unit: 'g', name: 'Zwiebeln' },
    ]).map(({ key, ...r }) => ({ id: 'auto:' + key, ...r }))
    const { upserts, deletes } = diffShopping(existing, auto)
    const by = Object.fromEntries(upserts.map((x) => [x.name, x]))
    expect(by['Sahne'].checked).toBe(true) // beide alten Sahne-Zeilen waren abgehakt
    expect(by['Zwiebeln'].checked).toBe(false) // nur eine von zwei war abgehakt
    expect(deletes).not.toContain('m:1') // eigene Einträge bleiben
  })
})

describe('Woche', () => {
  it('ab Freitag wird die nächste Woche geplant', () => {
    expect(upcomingWeek(new Date('2026-11-11T12:00'))).toBe('2026-11-09') // Mi
    expect(upcomingWeek(new Date('2026-11-13T12:00'))).toBe('2026-11-16') // Fr
    expect(upcomingWeek(new Date('2026-11-15T12:00'))).toBe('2026-11-16') // So
  })
})

import { aisleOf, groupByAisle } from '../src/lib/aisles.js'

describe('Einkaufsliste nach Ladenbereichen', () => {
  it.each([
    ['Zwiebeln', 'obst'],
    ['Kartoffeln, mehligkochend', 'obst'],
    ['Zuckerschoten', 'obst'],
    ['Petersilie', 'obst'],
    ['Naan-Brot', 'brot'],
    ['Ei', 'kuehl'],
    ['Eier (Größe L)', 'kuehl'],
    ['Crème fraîche', 'kuehl'],
    ['Gnocchi (Kühlregal)', 'kuehl'],
    ['Schweinefilet', 'fleisch'],
    ['gemischtes Hackfleisch', 'fleisch'],
    ['gehackte Tomaten', 'trocken'],
    ['Kokosmilch', 'trocken'],
    ['Kidneybohnen (Dose)', 'trocken'],
    ['Olivenöl', 'gewuerze'],
    ['Kürbiskernöl', 'gewuerze'],
    ['Zitronensaft', 'gewuerze'],
    ['Paprikapulver, edelsüß', 'gewuerze'],
    ['gesalzene Erdnüsse', 'backen'],
    ['Mehl', 'backen'],
    ['Rucola', 'obst'],
    ['Weißwein, trocken', 'getraenke'],
    ['Erbsen (TK)', 'tk'],
    ['Klopapier', 'drogerie'],
  ])('%s → %s', (name, aisle) => {
    expect(aisleOf(name)).toBe(aisle)
  })

  it('alle Zutaten aus rezepte.yaml haben einen Bereich', () => {
    const { recipes } = parseCatalog(realCatalog)
    const names = [...new Set(recipes.flatMap((r) => r.ingredients.map((i) => i.name)))]
    const unknown = names.filter((n) => aisleOf(n) === 'sonstiges' && n !== 'Wasser')
    expect(unknown).toEqual([])
  })

  it('gruppiert in Ladenreihenfolge', () => {
    const groups = groupByAisle([{ name: 'Klopapier' }, { name: 'Milch' }, { name: 'Tomaten' }])
    expect(groups.map((g) => g.id)).toEqual(['obst', 'kuehl', 'drogerie'])
  })
})
