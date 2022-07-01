//
//  RezeptSammlung.swift
//  weekleat
//
//  Created by Philipp Jenny on 24.06.22.
//

import SwiftUI

struct RezeptSammlung: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var recipies: FetchedResults<Recipie>
    
    @State private var passRecipie: Recipie? = nil
    @State private var showingAddScreen = false
    @State private var showingEditScreen = false
    @State public var currentLetter = ""
    @State private var searchText = ""
    
    @State private var dummyRezepte = Rezepte.dummyRezepte

    
    
    var body: some View {
        NavigationView{
            if recipies.count > 0{
                List(recipies) {recipie in
                        if searchText == "" {
                            ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: tagConverter(tagString: recipie.wrappedTags), backgroundColor: "PureWhite", portion: Int(recipie.portion))
                                .onTapGesture{
                                  passRecipie = recipie
                                    showingEditScreen.toggle()
                                }
                                .swipeActions{
                                    Button{
                                        withAnimation{
                                            moc.delete(recipie)
                                            try? moc.save()
                                        }
                                      
                                    } label: {
                                        Label("", systemImage: "trash")
                                    }
                                    .tint(Color("RedLight"))
                                }
                                .swipeActions(edge: .leading){
                                    Button{
                                        print("Star")
                                    } label: {
                                        Label("", systemImage: "star")
                                    }
                                    .tint(Color("YellowLight"))
                                }
                                
                                
                           
                        } else {
                            if recipie.wrappedTitle.lowercased().contains(searchText.lowercased()) {
                                ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: [.Veggi, .Schnell], backgroundColor: "PureWhite", portion: Int(recipie.portion))
                                    .swipeActions{
                                        Button{
                                            moc.delete(recipie)
                                            try? moc.save()
                                        } label: {
                                            Label("", systemImage: "trash")
                                        }
                                        .tint(Color("RedLight"))
                                    }
                                    .swipeActions(edge: .leading){
                                        Button{
                                            print("Star")
                                        } label: {
                                            Label("", systemImage: "star")
                                        }
                                        .tint(Color("YellowLight"))
                                    }
                                    
                            }
                        }

                   

                }
                .searchable(text: $searchText)
                .navigationTitle("Rezepte")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Label("", systemImage: "plus")
                        }
                    }

                }
                .sheet(isPresented: $showingAddScreen) {
                    AddRecipieView()
                }

               .sheet(isPresented: $showingEditScreen){
                   EditRecipieView(rezept: passRecipie ?? recipies[0])
               }
            } else {
                VStack{
                    ZStack{
         
                        Image("pizza")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                Text("Sieht ziemlich leer aus hier...")
                        .font(.system(size: 20))
                        .padding()
                    Button{
                        for dummyRezept in dummyRezepte {
                    
                            let newRecipie = Recipie(context: moc)
                            newRecipie.id = UUID()
                            newRecipie.title = dummyRezept.title
                            newRecipie.portion = Int16(5)
                            newRecipie.foodType = chooseImages(title: dummyRezept.title)
                            newRecipie.colorTheme = Int16(foodTypetoColorInt(foodType: chooseImages(title: dummyRezept.title)))
                            
                            
                            
                            for ingredient in dummyRezept.ingredients {
                                let newIngredient = Ingredient(context: moc)
                                newIngredient.title = returnIngredient(ingredientEntry: ingredient)
                                newIngredient.amount = Float(returnAmount(ingredientEntry: ingredient))
                                newIngredient.unit = returnUnit(ingredientEntry: ingredient)
                                newRecipie.addToIngredients(newIngredient)
                           
                            }
                            
                           
                            
                       

                            newRecipie.tags = dummyRezept.tags
                            
                            try? moc.save()
                        }
                     

                    }label:{
                        Text("Rezepte generieren")
                    }
                    .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(8)
                        
                }
               
            }
                
        }
    }
    

}

//struct RezeptSammlung_Previews: PreviewProvider {
//    static var previews: some View {
//        RezeptSammlung()
//    }
//}
