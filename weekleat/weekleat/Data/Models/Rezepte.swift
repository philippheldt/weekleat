//
//  Rezepte.swift
//  weekleat
//
//  Created by Philipp Jenny on 12.05.22.
//

import Foundation
import SwiftUI

struct Rezept: Identifiable {
    let id: UUID
    var title: String
    var tags: String

    var ingredients: [String] = []
    
    init(id: UUID = UUID(), title: String,tags: String, ingredients: [String] ){
        self.id = id
        self.title = title
        self.tags = tags
        self.ingredients = ingredients
    }
}

struct Rezepte {
    static let dummyRezepte = [
        Rezept(title: "Kartoffelsuppe", tags: "vegetarisch,Kartoffeln,schnell", ingredients: ["1 Zwiebel","1 Knoblauchzehe","2 Karotten","375g Kartoffeln","1EL Öl","750ml Gemüsebrühe"]),
        Rezept(title: "Kürbissuppe", tags: "vegetarisch,schnell", ingredients: ["2kg Kürbis","1 Zwiebel","1 Knoblauchzehe","3 Karotten","375g Kartoffeln","1EL Öl","750ml Gemüsebrühe","1TL Currypulver","1EL Zucker","200ml Creme fraiche"]),
        Rezept(title: "Pizzasuppe", tags: "schnell", ingredients: ["1EL Öl","1 Zwiebel","50g Hackfleisch","100g Tomaten","1EL Tomatenmark","500ml Gemüsebrühe","2 Pilze"]),
        Rezept(title: "Tom Ka Suppe", tags: "schnell", ingredients: ["500g Hähnchenfleisch","1 Zwiebel","400ml Kokosmilch","400ml Wasser","1 Zitrone","200g Reis"]),
        Rezept(title: "Kartoffelsalat", tags: "Kartoffeln,vegetarisch", ingredients: ["900g Kartoffeln","1 Zwiebel","5EL Essig","1TL Senf"]),
        Rezept(title: "Reissalat", tags: "Reis,vegetarisch", ingredients: ["125g Reis","1 Lauch","2 Karotten","1TL Essig"]),
        Rezept(title: "Kartoffelpuffer", tags: "Kartoffeln,vegetarisch", ingredients: ["900g Kartoffeln","1 Zwiebel","5EL Essig","1TL Senf"]),
        Rezept(title: "Käsespätzle", tags: "Nudeln,vegetarisch", ingredients: ["200g Mehl","2 Eier","200g Käse"]),
        Rezept(title: "Maultaschen", tags: "Nudeln", ingredients: ["200g Mehl","2 Eier","200g Käse", "200g Hackfleisch"]),
        Rezept(title: "Zucchini Pasta", tags: "Nudeln,vegetarisch", ingredients: ["200g Mehl","2 Zucchini","200g Käse","200ml Sahne"]),
        Rezept(title: "Pasta & Tomatensoße", tags: "Nudeln,vegetarisch", ingredients: ["200g Mehl","2 Zucchini","200g Käse","200ml Sahne"]),
        Rezept(title: "Pilzsoße", tags: "Nudeln,vegetarisch", ingredients: ["200g Mehl","2 Pilze","200g Käse","200ml Sahne"]),
        Rezept(title: "Spinatsoße", tags: "Nudeln,vegetarisch", ingredients: ["200g Mehl","200g Spinat","200g Käse","200ml Sahne"]),
        Rezept(title: "Serbisches Reisgericht", tags: "Reis", ingredients: ["200g Mehl","200g Spinat","200g Käse","200g Hackfleisch"]),
        Rezept(title: "Biryani", tags: "Reis", ingredients: ["200g Reis","200g Spinat", "200g Hackfleisch"]),
        Rezept(title: "Paneer Butter Masala", tags: "Reis,vegetarisch", ingredients: ["200g Reis","200g Spinat","200g Käse","200g Käse"]),
        Rezept(title: "Moussaka", tags: "Reis", ingredients: ["200g Reis","200g Spinat","200g Käse","200g Hackfleisch"]),
        Rezept(title: "Thunfischauflauf", tags: "Reis", ingredients: ["200g Reis","200g Fisch","200g Käse","200g Hackfleisch"]),
        Rezept(title: "Pfannkuchen", tags: "gebacken,vegetarisch", ingredients: ["200g Mehl","2 Eier","200ml Milch"]),
        Rezept(title: "Pizza Salami", tags: "gebacken", ingredients: ["200g Mehl","2 Eier","200ml Milch","200g Salami"]),
        Rezept(title: "Pizza Margarita", tags: "gebacken,vegetarisch", ingredients: ["200g Mehl","2 Eier","200ml Milch","200g Käse"]),
        Rezept(title: "Enchiladas", tags: "gebacken,vegetarisch", ingredients: ["200g Mehl","2 Eier","200ml Milch","200g Käse"]),
        Rezept(title: "Burger", tags: "gebacken", ingredients: ["5 Burgerbrötchen","2 Eier","200ml Milch","200g Käse", "500g Hackfleisch"]),
        Rezept(title: "Döner", tags: "gebacken", ingredients: ["200g Dönerfleisch","2 Eier","200ml Milch","200g Käse", "1 Salat"]),
        Rezept(title: "Schweinefilet", tags: "gebacken,Nudeln", ingredients: ["200g Schweinefleisch","100g Speck","200ml Milch","200g Käse", "1 Salat"]),
        
    ]
}
