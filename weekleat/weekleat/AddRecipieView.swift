//
//  AddRecipieView.swift
//  weekleat
//
//  Created by Philipp Jenny on 24.06.22.
//

import SwiftUI

struct AddRecipieView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var portion = 5
    let step = 1
    let range = 1...50
    @State private var foodType = ""
    @State private var ingredients: [String] = []
    @State private var ingredientsEntry: String = ""
    @State private var amount: Int = 0
    @State private var unit: String = ""
    
    
    let foodTypes = ["enchilada", "pancake", "pasta", "pizza", "zucchini"]
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Rezeptname", text: $title)
                    Stepper(value: $portion, in: range, step: step) {
                        HStack{
                            Text("Portionen:")
                            Spacer()
                            Text("\(portion)")
                        }
                    }
                    HStack{
                        Text("Essensart")
                        Spacer()
                        Picker("Essensart", selection: $foodType){
                            ForEach(foodTypes, id: \.self) {
                                
                                let first = String($0.prefix(1)).capitalized
                                let other = String($0.dropFirst())
                                let all = first + other
                                
                                HStack {
                                    //   Image("pasta")
                                    //     .scaledToFit()
                                    Text(all)
                                    
                                }
                                
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                }
                Section{
                    List(ingredients, id:\.self) { ingredient in
                        Text(ingredient)
                        
                    }
                    HStack{
                        TextField("250g Mehl", text: $ingredientsEntry)
                        Button {
                            if ingredientsEntry != ""{
                                //Creating array from Words in TextFioeld
                                let ingrArr = ingredientsEntry.components(separatedBy: " ")
                                
                             
                                for item in ingrArr{
                                    //Filtering out the Numbers
                                    let ingrArrNum = item.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                    var checkNum: Bool = false //If an array contains a Number, this will be updated
                                    for numItem in ingrArrNum{
                                        if let number = Int(numItem) {
                                            amount = number
                                            checkNum = true
                                        }
                                        
                                    }
                                    
                                    if checkNum == true {
                                        var unitDef: String = ""
                                        let characters = Array(item) //Split up array position in single characters
                                        for character in characters {
                                            
                                            if !character.isNumber{ //If its not a number it may be the unit, so its added to Unit
                                                unitDef = "\(unitDef)\(character)"
                                            }
                                            
                                        }
                                        unit = unitDef
                                    }
                                    
                                }
                                
                                ingredients += ["\(ingredientsEntry)"]
                                ingredientsEntry = ""
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                Section{
                    Button("Hinzufügen") {
                        let newRecipie = Recipie(context: moc)
                        newRecipie.id = UUID()
                        newRecipie.title = title
                        newRecipie.portion = Int16(portion)
                        newRecipie.foodType = foodType
                        
                        
                        
                        for ingredient in ingredients {
                            let newIngredient = Ingredient(context: moc)
                            newIngredient.title = ingredient
                            newIngredient.amount = Int16(amount)
                            newIngredient.unit = unit
                            newRecipie.addToIngredients(newIngredient)
                        }
                        
                        if foodType == "enchilada" || foodType == "pizza" {
                            newRecipie.colorTheme = 4
                        } else if foodType == "pasta" || foodType == "pancake" {
                            newRecipie.colorTheme = 0
                        } else if foodType == "zucchini" {
                            newRecipie.colorTheme = 7
                        }
                        try? moc.save()
                        dismiss()
                        
                    }
                }
            }
            .navigationTitle("Rezept erstellen")
        }
    }
}

struct AddRecipieView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipieView()
    }
}
