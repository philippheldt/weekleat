//
//  Rezepte.swift
//  weekleat
//
//  Created by Philipp Jenny on 12.05.22.
//

import Foundation

struct Rezept: Identifiable {
    let id: UUID
    var title: String
    var portion: Int
    var tags: [TagIcon] = []
    var colorTheme: ColorTheme
    var foodType: String
    var ingredients: [String]
    
    init(id: UUID = UUID(), title: String, portion: Int,tags: [TagIcon], colorTheme: ColorTheme, foodType: String, ingredients: [String] ){
        self.id = id
        self.title = title
        self.portion = portion
        self.tags = tags
        self.colorTheme = colorTheme
        self.foodType = foodType
        self.ingredients = ingredients
    }
}

struct Rezepte {
    static let dummyRezepte = [
        Rezept(title: "Pizza", portion: 5, tags: [.Schnell], colorTheme: .RedLight, foodType: "pizza", ingredients: ["Mehl, 500g", "Tomatensoße, 200m"]),
        Rezept(title: "Käsespätzle", portion: 2, tags: [.Schnell, .Veggi], colorTheme: .YellowLight, foodType: "pasta", ingredients: ["Mehl, 500g"]),
        Rezept(title: "Zucchini Pasta", portion: 5, tags: [.Veggi], colorTheme: .BlueMedium, foodType: "zucchini", ingredients: ["Mehl, 500g"]),
        Rezept(title: "Enchiladas", portion: 5, tags: [.Lang], colorTheme: .RedDark, foodType: "enchilada", ingredients: ["Mehl, 500g"]),
        Rezept(title: "Pfannkuchen", portion: 4, tags: [.Schnell, .Veggi], colorTheme: .YellowMedium, foodType: "pancake", ingredients: ["Mehl, 500g"]),
        Rezept(title: "Moussaka", portion: 5, tags: [.Veggi], colorTheme: .RedLight, foodType: "pizza", ingredients: ["Mehl, 500g"]),
    ]
}
