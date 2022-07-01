//
//  EditRecipieView.swift
//  weekleat
//
//  Created by Philipp Jenny on 30.06.22.
//

import SwiftUI

struct EditRecipieView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var rezept: Recipie
    
  
    @State private var title = ""
    @State private var portion = 5
    @State private var previousportion = 0
    let step = 1
    let range = 1...50
    @State private var foodType = ""
    @State private var ingredients: [String] = []
    @State private var ingredientsEntry: String = ""
    @State private var amount: Float = 0
    @State private var colorTheme: Int = 0
    @State private var unit: String = ""
    @State private var tag: String = ""
    @State private var tags: [Tag] = [
        Tag(name: "vegetarisch", isActive: false, index: 0),
        Tag(name: "vegan", isActive: false, index: 1),
        Tag(name: "Kartoffeln", isActive: false, index: 2),
        Tag(name: "Nudeln", isActive: false, index: 3),
        Tag(name: "Reis", isActive: false, index: 4),
        Tag(name: "Salat", isActive: false, index: 5),
        Tag(name: "schnell", isActive: false, index: 6),
        Tag(name: "gebacken", isActive: false, index: 7),
        Tag(name: "aufwändig", isActive: false, index: 8)
    ]
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(foodTypetoColorString(foodType: chooseImages(title: title))))
                                .frame(width: 75, height: 75)
                            Image(chooseImages(title: title))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 65, height: 65)
                        }.padding([.top, .bottom, .trailing])
                        TextField("Rezeptname", text: $title)
                    }
                    
                    Stepper(value: $portion, in: range, step: step) {
                        HStack{
                            Text("Portionen:")
                            Spacer()
                            Text("\(portion)")
                        }
                    }
                    
                    ScrollView(.horizontal) {
                        
                        HStack {
                            ForEach(tags, id:\.id) { tag in
                                SingleTagViewButton(iconName: tagConverter(tagString: tag.name)[0].IconOutline, color: foodTypeToColorTheme(foodType: chooseImages(title: title)), backgroundColor: "BlueLight" , textContent: tag.name, amount: 1, active: tag.isActive)
                                    .onTapGesture {
                                        tags[tag.index].isActive.toggle()
                                    }
                            }
                        }
                    }
                    
                    
                    
                }
                Section{
                    List(ingredients, id:\.self) { ingredient in
                        Text(ingredient)
                            .swipeActions{
                                Button{
                                    withAnimation{
                                        for rIngredient in rezept.ingredientsArray {
                                            if rIngredient.wrappedTitle.contains(returnIngredient(ingredientEntry: ingredient)){
                                                moc.delete(rIngredient)
                                                try? moc.save()
                                            }
                                        }
                                        ingredients = []
                                        for ingredient in rezept.ingredientsArray {
                                            ingredients.append("\(ingredient.amount)\(ingredient.wrappedUnit)\(ingredient.wrappedTitle)")
                                        }
                                    }
                                   
                                   
                                } label: {
                                    Label("", systemImage: "trash")
                                }
                                .tint(Color("RedLight"))
                            }
                        
                    }
                    HStack{
                        TextField("z.B. 250g Mehl", text: $ingredientsEntry)
                        Button {
                            if ingredientsEntry != ""{
                                //Creating array from Words in TextField
                                let ingrArr = ingredientsEntry.components(separatedBy: " ")
                                
                                
                                for item in ingrArr{
                                    //Filtering out the Numbers
                                    let ingrArrNum = item.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                    var checkNum: Bool = false //If an array contains a Number, this will be updated
                                    for numItem in ingrArrNum{
                                        if let number = Float(numItem) {
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

            }
            .navigationTitle(title)
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Abbrechen")
                    })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        
                            rezept.title = title
                            rezept.portion = Int16(portion)
                            rezept.foodType = chooseImages(title: title)
                            rezept.colorTheme = Int16(foodTypetoColorInt(foodType: chooseImages(title: title)))
                            
                            
                            var tagString: String = ""
                            for tag in tags {
                                if tag.isActive {
                                    if tagString == ""{
                                        tagString = tag.name
                                    } else {
                                        tagString = "\(tagString),\(tag.name)"
                                     
                                    }
                                }
                            }
                            rezept.tags = tagString
                            
                            for rIngredient in rezept.ingredientsArray{
                                moc.delete(rIngredient)
                            }
                            for ingredient in ingredients {
                                let newIngredient = Ingredient(context: moc)
                                newIngredient.title = returnIngredient(ingredientEntry: ingredient)
                                newIngredient.amount = (returnAmount(ingredientEntry: ingredient)/Float(previousportion)*Float(portion))
                                newIngredient.unit = returnUnit(ingredientEntry: ingredient)
                                rezept.addToIngredients(newIngredient)
                           
                            }
                            
                            
                            
                            try? moc.save()
                            dismiss()
                    }, label: {
                        Text("Speichern")
                    })
                }
            }


        }
       
        .onAppear{
            title = rezept.wrappedTitle
            portion = Int(rezept.portion)
            previousportion = Int(rezept.portion)
            foodType = rezept.wrappedFoodType
            colorTheme = Int(rezept.colorTheme)
            tag = rezept.wrappedTags
            
            for (index, t) in tags.enumerated() {
                if tag.contains(t.name) {
                    tags[index].isActive = true
                }
            }
            
            for ingredient in rezept.ingredientsArray {
                ingredients.append("\(ingredient.amount.clean)\(ingredient.wrappedUnit)\(ingredient.wrappedTitle)")
            }
            
            
       }
    }
        
        
}
    

//struct EditRecipieView_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
