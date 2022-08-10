//
//  RecipieImageLogic.swift
//  weekleat
//
//  Created by Philipp Jenny on 27.06.22.
//

import Foundation

func chooseImages(title: String) -> String {
    var titlesArray: [String] = title.components(separatedBy: " ")
    var imageName = ""
    for (index, titleItem) in titlesArray.enumerated() {
        if titleItem == ""{
            titlesArray.remove(at: index)
        }

        let titleLowercase = titleItem.lowercased()
        if imageName.count < 2{
        if titleLowercase.contains("wraps") || titleLowercase.contains("wrap") || titleLowercase.contains("döner") || titleLowercase.contains("enchilada") || titleLowercase.contains("tasche") || titleLowercase.contains("pita") || titleLowercase.contains("quesadilla") {
            imageName = "enchilada"
        }  else if  titleLowercase.contains("zucchini") || titleLowercase.contains("gurke"){
            imageName = "zucchini"
        } else if titleLowercase.contains("lasagne") || titleLowercase.contains("auflauf"){
            imageName = "lasagne"
        } else if titleLowercase.contains("aprikose"){
            imageName = "apricot"
        } else if titleLowercase.contains("brokkoli") || titleLowercase.contains("blumenkohl"){
            imageName = "brokkoli"
        } else if titleLowercase.contains("chilli") || titleLowercase.contains("spitzpaprika") || titleLowercase.contains("scharf") || titleLowercase.contains("curry") || titleLowercase.contains("masala"){
            imageName = "chilli"
        } else if titleLowercase.contains("butter") || titleLowercase.contains("magerine"){
            imageName = "butter"
        } else if titleLowercase.contains("karotte") || titleLowercase.contains("pastinake") || titleLowercase.contains("möhre") || titleLowercase.contains("mohrrübe") || titleLowercase.contains("carrot")  || titleLowercase.contains("gemüse"){
            imageName = "carrot"
        } else if titleLowercase.contains("hähnchen") || titleLowercase.contains("hühner") || titleLowercase.contains("brust") || titleLowercase.contains("schenkel") || titleLowercase.contains("haxe") || titleLowercase.contains("huhn") || titleLowercase.contains("chicken") || titleLowercase.contains("wings") || titleLowercase.contains("pute"){
            imageName = "chicken"
        }  else if titleLowercase.contains("erbse") || titleLowercase.contains("peas") || titleLowercase.contains("bohne"){
            imageName = "erbsen"
        } else if titleLowercase.contains("flammkuchen") || titleLowercase.contains("flambe"){
            imageName = "flambe"
        } else if titleLowercase.contains("klöße") || titleLowercase.contains("knödel"){
            imageName = "kloss"
        } else if titleLowercase.contains("kokos"){
            imageName = "kokos"
        } else if titleLowercase.contains("lasagne"){
            imageName = "lasagne"
        } else if titleLowercase.contains("frühlingszwiebel") || titleLowercase.contains("lauch") || titleLowercase.contains("porree"){
            imageName = "lauch"
        } else if titleLowercase.contains("knoblauch") || titleLowercase.contains("zwiebel"){
            imageName = "knoblauch"
        } else if titleLowercase.contains("linsen"){
            imageName = "linsen"
        } else if titleLowercase.contains("mais"){
            imageName = "mais"
        } else if titleLowercase.contains("milch") || titleLowercase.contains("sahne") || titleLowercase.contains("creme") || titleLowercase.contains("schmand") || titleLowercase.contains("joghurt") || titleLowercase.contains("rahm"){
            imageName = "milk"
        } else if titleLowercase.contains("paprika"){
            imageName = "paprika"
        }else if titleLowercase.contains("radieschen"){
            imageName = "radies"
        }else if titleLowercase.contains("wurst") || titleLowercase.contains("würstchen") || titleLowercase.contains("sausage") || titleLowercase.contains("hotdog") || titleLowercase.contains("salami") || titleLowercase.contains("schinken") || titleLowercase.contains("lyoner") || titleLowercase.contains("wiener"){
            imageName = "sausage"
        } else if titleLowercase.contains("pfeffer") || titleLowercase.contains("salz") || titleLowercase.contains("pulver") || titleLowercase.contains("koriander") || titleLowercase.contains("schnittlauch") || titleLowercase.contains("petersilie") || titleLowercase.contains("kräuter") || titleLowercase.contains("kreuzkümmel") || titleLowercase.contains("kümmel") || titleLowercase.contains("kurkuma") || titleLowercase.contains("basilikum") || titleLowercase.contains("muskat") || titleLowercase.contains("senf") || titleLowercase.contains("zimt"){
            imageName = "spice"
        } else if titleLowercase.contains("pfannkuchen") || titleLowercase.contains("kaiserschmarrn") || titleLowercase.contains("pancake") || titleLowercase.contains("eierkuchen"){
            imageName = "pancake"
        } else if titleLowercase.contains("schinken") || titleLowercase.contains("speck") {
            imageName = "bacon"
        }else if titleLowercase.contains("fleisch") || titleLowercase.contains("steak") || titleLowercase.contains("schnitzel") {
            imageName = "steak"
        } else if titleLowercase.contains("burger"){
            imageName = "burger"
        } else if titleLowercase.contains("käse") || titleLowercase.contains("mozzarella") || titleLowercase.contains("emmentaler") || titleLowercase.contains("gouda"){
            imageName = "cheese"
        } else if titleLowercase.contains("pilz") || titleLowercase.contains("champignon") || titleLowercase.contains("champion"){
            imageName = "mushroom"
        } else if titleLowercase.contains("zitrone"){
            imageName = "lemon"
        } else if titleLowercase.contains("kartoffel") || titleLowercase.contains("potatoe"){
            imageName = "potatoe"
        } else if titleLowercase.contains("kürbis"){
            imageName = "pumpkin"
        } else if titleLowercase.contains("reis"){
            imageName = "rice"
        } else if titleLowercase.contains("suppe"){
            imageName = "soup"
        } else if titleLowercase.contains("pizza"){
            imageName = "pizza"
        }else if titleLowercase.contains("eier"){
            imageName = "egg"
        } else if titleLowercase.contains("pasta") || titleLowercase.contains("nudel") || titleLowercase.contains("spaghetti") || titleLowercase.contains("spaghetti") || titleLowercase.contains("spätzle") || titleLowercase.contains("tagliatelle") || titleLowercase.contains("lasagne") {
                imageName = "pasta"
            }
        }
        }
    if imageName == "" && titlesArray.count > 0 {
        switch titlesArray[0].prefix(1).uppercased(){
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


