//
//  RecipieImageLogic.swift
//  weekleat
//
//  Created by Philipp Jenny on 27.06.22.
//

import Foundation

func chooseImages(title: String) -> String {
    let titlesArray: [String] = title.components(separatedBy: " ")
    var imageName = ""
    for titleItem in titlesArray {
        switch titleItem.lowercased() {
        case "pasta", "nudeln", "nudel", "spaghetti", "spätzle", "tagliatelle":
            imageName = "pasta"
        case "wraps", "wrap", "döner", "enchilada", "tasche", "taschen", "pita":
            imageName = "enchilada"
        case "gemüse", "karotte", "karotten", "auflauf", "zucchini":
            imageName = "zucchini"
        case "pfannkuchen", "pancake":
            imageName = "pancake"
        default:
            if imageName == ""{
                imageName = "pizza"
            }
        }
    }
    return imageName
}

let colors: [ColorTheme] = [.YellowLight, .YellowMedium, .YellowDark, .RedLight, .RedMedium, .RedDark, .BlueLight, .BlueMedium, .BlueDark ]

func intToColorTheme(colorInt: Int) -> ColorTheme {
    return colors[colorInt]
}

func foodTypetoColorInt(foodType: String) -> Int{
    var returnColor: Int = 0
    switch foodType.lowercased() {
    case "pasta":
        returnColor = 0
    case "pancake":
        returnColor = 1
    case "pizza":
        returnColor = 3
    case "enchilada":
        returnColor = 5
    case "zucchini":
        returnColor = 7
    default:
        returnColor = 6

    }
    
    return returnColor
}

func foodTypetoColorString(foodType: String) -> String {
    let numberCode = foodTypetoColorInt(foodType: foodType)
    let colorThemeRead = colors[numberCode]
    let returnTheme = colorThemeRead.rawValue
    
    return "\(returnTheme)"
}

func foodTypeToColorTheme(foodType: String) -> ColorTheme {
    let numberCode = foodTypetoColorInt(foodType: foodType)
    let colorThemeRead = colors[numberCode]
  
    
    return colorThemeRead
}


func returnFirstLetter(word: String) -> String {
    let currentword: String = word.uppercased()
    let wordArray = Array(currentword)
    return String(wordArray[0])
}
