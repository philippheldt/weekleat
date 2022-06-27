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
        case "gemüse", "karotte", "karotten", "auflauf":
            imageName = "zucchini"
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
    case "zucchini":
        returnColor = 7
    case "pizza":
        returnColor = 3
    default:
        returnColor = 4
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
