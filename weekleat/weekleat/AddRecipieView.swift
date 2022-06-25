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
    @State private var ingredientSingle: String = ""
    @State private var ingredientString: String = ""
    
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
                                    Image("pasta")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 1, height: 1)
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
                        TextField("Zutaten", text: $ingredientSingle)
                        Button {
                            if ingredientSingle != ""{
                                ingredients += ["\(ingredientSingle)"]
                                ingredientSingle = ""
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
                            if ingredientString != "" {
                                ingredientString = "\(ingredientString),\(ingredient)"
                            } else {
                                ingredientString = ingredient
                            }
                        }
                        print(ingredientString)
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
