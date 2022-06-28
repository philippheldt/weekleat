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
        let titleLowercase = titleItem.lowercased()
        if imageName.count < 2{
        if titleLowercase.contains("pasta") || titleLowercase.contains("nudel") || titleLowercase.contains("spaghetti") || titleLowercase.contains("spaghetti") || titleLowercase.contains("spätzle") || titleLowercase.contains("tagliatelle") || titleLowercase.contains("lasagne") {
            imageName = "pasta"
        } else if titleLowercase.contains("wraps") || titleLowercase.contains("wrap") || titleLowercase.contains("döner") || titleLowercase.contains("enchilada") || titleLowercase.contains("tasche") || titleLowercase.contains("pita") {
            imageName = "enchilada"
        }  else if titleLowercase.contains("gemüse") || titleLowercase.contains("karotte") || titleLowercase.contains("auflauf") || titleLowercase.contains("zucchini"){
            imageName = "zucchini"
        } else if titleLowercase.contains("pfannkuchen") || titleLowercase.contains("pancake") || titleLowercase.contains("eierkuchen"){
            imageName = "pancake"
        } else if titleLowercase.contains("schinken") || titleLowercase.contains("speck") || titleLowercase.contains("fleisch"){
            imageName = "bacon"
        } else if titleLowercase.contains("burger"){
            imageName = "burger"
        } else if titleLowercase.contains("käse") || titleLowercase.contains("mozarella") || titleLowercase.contains("emmentaler") || titleLowercase.contains("gouda"){
            imageName = "cheese"
        } else if titleLowercase.contains("pilz") || titleLowercase.contains("champignon"){
            imageName = "mushroom"
        } else if titleLowercase.contains("zitrone"){
            imageName = "lemon"
        } else if titleLowercase.contains("kartoffel") || titleLowercase.contains("potatoe"){
            imageName = "potatoe"
        } else if titleLowercase.contains("kürbis"){
            imageName = "pumpkin"
        } else if titleLowercase.contains("salat") || titleLowercase.contains("spinat"){
            imageName = "salad"
        } else if titleLowercase.contains("reis"){
            imageName = "rice"
        } else if titleLowercase.contains("schupfnudel"){
            imageName = "schupfnudel"
        } else if titleLowercase.contains("suppe"){
            imageName = "soup"
        } else if titleLowercase.contains("tomate"){
            imageName = "tomato"
        } else if titleLowercase.contains("waffel"){
            imageName = "waffel"
        }else if titleLowercase.contains("pizza"){
            imageName = "pizza"
        }
        }
        }
    if imageName == "" {
        switch titlesArray[0].prefix(1){
        case "A": imageName = "a"
        case "B": imageName = "b"
        case "C": imageName = "c"
        case "D": imageName = "d"
        case "E": imageName = "e"
        case "F": imageName = "f"
        case "G": imageName = "g"
        case "H": imageName = "h"
        case "I": imageName = "i"
        case "J": imageName = "j"
        case "K": imageName = "k"
        case "L": imageName = "l"
        case "M": imageName = "m"
        case "N": imageName = "n"
        case "O": imageName = "o"
        case "P": imageName = "p"
        case "Q": imageName = "q"
        case "R": imageName = "r"
        case "S": imageName = "s"
        case "T": imageName = "t"
        case "U": imageName = "u"
        case "V": imageName = "v"
        case "W": imageName = "w"
        case "X": imageName = "x"
        case "Y": imageName = "y"
        case "Z": imageName = "z"
        default: imageName = ""
        }
        
        
    }
    return imageName
}

func chooseTags(title: String) -> Int {
    let titlesArray: [String] = title.components(separatedBy: " ")
    var tagArray: Int = 0
    for titleItem in titlesArray {
        switch titleItem.lowercased() {
        case "pasta", "nudeln", "nudel", "spaghetti", "spätzle", "tagliatelle":
            tagArray = 3
        case "reis", "reispfanne":
            tagArray = 4
        case "kartoffel", "kartoffeln", "kartoffelgratin", "bratkartoffeln", "brägele", "kartoffelpuffer", "pommes", "kartoffelbrei", "kartoffelpüree":
            tagArray = 2
        case "salat":
            tagArray = 5
        default:
            tagArray = 10
            
        }
    }
    return tagArray
}

let colors: [ColorTheme] = [.YellowLight, .YellowMedium, .YellowDark, .RedLight, .RedMedium, .RedDark, .BlueLight, .BlueMedium, .BlueDark ]

func intToColorTheme(colorInt: Int) -> ColorTheme {
    return colors[colorInt]
}

func foodTypetoColorInt(foodType: String) -> Int{
    var returnColor: Int = 0
    switch foodType.lowercased() {
    case "pasta", "burger", "cheese", "lemon", "schupfnudel", "b", "e", "h", "k", "n", "q", "t", "w", "z":
        returnColor = 0
    case "pancake", "potatoe", "pumpkin", "waffel":
        returnColor = 1
    case "mushroom":
        returnColor = 2
    case "pizza", "soup", "a", "d", "g", "j", "m", "p", "s", "v", "y":
        returnColor = 3
    case "enchilada", "bacon", "tomato":
        returnColor = 5
    case "zucchini", "salad", "rice", "c", "f", "i", "l", "o", "r", "u", "x":
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


