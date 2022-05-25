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
    
    init(id: UUID = UUID(), title: String, portion: Int,tags: [TagIcon], colorTheme: ColorTheme, foodType: String ){
        self.id = id
        self.title = title
        self.portion = portion
        self.tags = tags
        self.colorTheme = colorTheme
        self.foodType = foodType
    }
}

struct Rezepte {
    static let dummyRezepte = [
        Rezept(title: "Pizza", portion: 5, tags: [.Schnell, .Veggi], colorTheme: .RedLight, foodType: "pizza"),
        Rezept(title: "Käsespätzle", portion: 2, tags: [.Schnell, .Veggi], colorTheme: .YellowLight, foodType: "pasta"),
        Rezept(title: "Zucchini Pasta", portion: 5, tags: [.Schnell, .Veggi], colorTheme: .BlueMedium, foodType: "zucchini"),
        Rezept(title: "Enchiladas", portion: 5, tags: [.Schnell, .Veggi], colorTheme: .RedDark, foodType: "enchilada"),
        Rezept(title: "Pfannkuchen", portion: 4, tags: [.Schnell, .Veggi], colorTheme: .YellowMedium, foodType: "pancake"),
        Rezept(title: "Moussaka", portion: 5, tags: [.Schnell, .Veggi], colorTheme: .RedDark, foodType: "pizza"),
    ]
}
