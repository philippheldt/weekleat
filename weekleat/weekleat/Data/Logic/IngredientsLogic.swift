//
//  IngredientsLogic.swift
//  weekleat
//
//  Created by Philipp Jenny on 30.06.22.
//

import Foundation

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

func returnUnit(ingredientEntry: String) -> String {
    let ingrArr = ingredientEntry.components(separatedBy: " ")
    var unitDef: String = ""
    for item in ingrArr{
        //Filtering out the Numbers
        let ingrArrNum = item.components(separatedBy: CharacterSet.decimalDigits.inverted)
        var checkNum: Bool = false //If an array contains a Number, this will be updated
        for numItem in ingrArrNum{
            if let number = Float(numItem){
                checkNum = true
            }
        }

        if checkNum == true {
           
            let characters = Array(item) //Split up array position in single characters
            for character in characters {
                
                if !character.isNumber && character != "."{ //If its not a number it may be the unit, so its added to Unit
                    unitDef = "\(unitDef)\(character)"
                   
                }
                
            }
          
            
        }
        
    }
    return unitDef
}


func returnAmount(ingredientEntry: String) -> Float {
    let ingrArr = ingredientEntry.components(separatedBy: " ")
    var amountString: String = ""
    var amount: Float = 1.0
    for item in ingrArr{
        //Filtering out the Numbers
        let ingrArrNum = item.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for (index, numItem) in ingrArrNum.enumerated(){
            if numItem != ""{
                if index == 0{
                    amountString = "\(numItem)"
                } else if index == 1 {
                    amountString = "\(amountString).\(numItem)"
                }
            }
            
        }
        
    }
    amount = Float(amountString) ?? 1.0
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








