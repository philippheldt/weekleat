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
    var portion: Int
    var tags: [TagIcon] = []
    var colorTheme: ColorTheme
    var foodType: String
    var ingredients: [Ingredients] = []
    
    init(id: UUID = UUID(), title: String, portion: Int,tags: [TagIcon], colorTheme: ColorTheme, foodType: String, ingredients: [Ingredients] ){
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
        Rezept(title: "Pizza", portion: 5, tags: [.Schnell], colorTheme: .RedLight, foodType: "pizza", ingredients: [Ingredients.init(title: "Mehl", amount: "500g", tag: .Schnell), Ingredients.init(title: "Eier", amount: "500g", tag: .Schnell)]),
        Rezept(title: "Käsespätzle", portion: 2, tags: [.Schnell, .Veggi], colorTheme: .YellowLight, foodType: "pasta", ingredients: [Ingredients.init(title: "Mehl", amount: "500g", tag: .Veggi), Ingredients.init(title: "Eier", amount: "500g", tag: .Weight)]),
        Rezept(title: "Zucchini Pasta", portion: 5, tags: [.Veggi], colorTheme: .BlueMedium, foodType: "zucchini", ingredients: [Ingredients.init(title: "Mehl", amount: "500g", tag: .Schnell), Ingredients.init(title: "Eier", amount: "500g", tag: .Schnell)]),
        Rezept(title: "Enchiladas", portion: 5, tags: [.Lang], colorTheme: .RedDark, foodType: "enchilada", ingredients: [Ingredients.init(title: "Mehl", amount: "500g", tag: .Schnell), Ingredients.init(title: "Eier", amount: "500g", tag: .Schnell)]),
        Rezept(title: "Pfannkuchen", portion: 4, tags: [.Schnell, .Veggi], colorTheme: .YellowMedium, foodType: "pancake", ingredients: [Ingredients.init(title: "Mehl", amount: "500g", tag: .Schnell), Ingredients.init(title: "Eier", amount: "500g", tag: .Schnell)]),
        Rezept(title: "Moussaka", portion: 5, tags: [.Veggi], colorTheme: .RedLight, foodType: "pizza", ingredients: [Ingredients.init(title: "Mehl", amount: "500g", tag: .Schnell), Ingredients.init(title: "Eier", amount: "500g", tag: .Schnell)]),
    ]
}
