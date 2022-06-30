//
//  IngredientsLogic.swift
//  weekleat
//
//  Created by Philipp Jenny on 30.06.22.
//

import Foundation

func returnUnit(ingredientEntry: String) -> String {
    let ingrArr = ingredientEntry.components(separatedBy: " ")
    var unitDef: String = ""
    for item in ingrArr{
        //Filtering out the Numbers
        let ingrArrNum = item.components(separatedBy: CharacterSet.decimalDigits.inverted)
        var checkNum: Bool = false //If an array contains a Number, this will be updated
        for numItem in ingrArrNum{
            if let number = Int(numItem){
                checkNum = true
            }
        }

        if checkNum == true {
           
            let characters = Array(item) //Split up array position in single characters
            for character in characters {
                
                if !character.isNumber{ //If its not a number it may be the unit, so its added to Unit
                    unitDef = "\(unitDef)\(character)"
                   
                }
                
            }
          
            
        }
        
    }
    return unitDef
}


func returnAmount(ingredientEntry: String) -> Int {
    let ingrArr = ingredientEntry.components(separatedBy: " ")
    var amount = 1
    for item in ingrArr{
        //Filtering out the Numbers
        let ingrArrNum = item.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for numItem in ingrArrNum{
            if let number = Int(numItem){
                amount = number
            }
        }
        
    }
    return amount
}

func returnIngredient(ingredientEntry: String) -> String {
    let ingrArr = ingredientEntry.components(separatedBy: " ")
    var ingredient = ""
    for (index, item) in ingrArr.enumerated(){
        let decimalCharacters = CharacterSet.decimalDigits

        let decimalRange = item.rangeOfCharacter(from: decimalCharacters)

        if decimalRange == nil && item.count > 2 {
            ingredient = "\(ingredient) \(item)"
            print(ingredient)
        } else if index+1 == ingrArr.count{
            ingredient = "\(ingredient) \(item)"
        } else {
            print("----------\(item)-----------")
        }

    }
    return ingredient
}








