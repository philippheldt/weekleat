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
    var tag: String
    var colorTheme: ColorTheme
    var foodType: String
    
    init(id: UUID = UUID(), title: String, portion: Int,tag: String, colorTheme: ColorTheme, foodType: String ){
        self.id = id
        self.title = title
        self.portion = portion
        self.tag = tag
        self.colorTheme = colorTheme
        self.foodType = foodType
    }
}

struct Rezepte {
    static let dummyRezepte = [
        Rezept(title: "Pizza", portion: 5, tag: "veggi", colorTheme: .RedLight, foodType: "pizza"),
        Rezept(title: "Käsespätzle", portion: 2, tag: "schnell", colorTheme: .YellowLight, foodType: "pasta"),
        Rezept(title: "Zucchini Pasta", portion: 5, tag: "veggi", colorTheme: .BlueMedium, foodType: "zucchini"),
        Rezept(title: "Enchiladas", portion: 5, tag: "fleisch", colorTheme: .RedDark, foodType: "enchilada"),
        Rezept(title: "Pfannkuchen", portion: 4, tag: "schnell", colorTheme: .YellowMedium, foodType: "pancake"),
        Rezept(title: "Moussaka", portion: 5, tag: "schnell", colorTheme: .RedDark, foodType: "pizza"),
    ]
}
