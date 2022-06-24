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
    @State private var foodType = "pasta"
    
    let foodTypes = ["enchilada", "pancake", "pasta", "pizza", "zucchini"]
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Rezeptname", text: $title)
                Picker("Portionen", selection: $portion){
                    ForEach(0..<10) {
                        Text(String($0))
                    }
                }
                Picker("Essensart", selection: $foodType){
                    ForEach(foodTypes, id: \.self) {
                        Text($0)
                    }
                }
                Section{
                    Button("Hinzufügen") {
                        let newRecipie = Recipie(context: moc)
                            newRecipie.id = UUID()
                            newRecipie.title = title
                            newRecipie.portion = Int16(portion)
                            newRecipie.foodType = foodType
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
