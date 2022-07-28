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
    
    @State var passRecipie: Recipie
    @State private var showingAddScreen = false
    @State private var showingEditScreen = false
    @State private var searchText = ""
    
    @State private var dummyRezepte = Rezepte.dummyRezepte

    
    
    var body: some View {
        NavigationView{
            if recipies.count > 0{
                ScrollView{
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            Text("Heute")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("28. JUL 2022")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        ListElementLarge()
                            .padding(.bottom)
                        Text("FREITAG")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding([.top, .leading])
                        ForEach(recipies, id:\.id) {recipie in
                            if searchText == "" {
                                ListElement(recipie: recipie)
                                    .onTapGesture{
                                        passRecipie = recipie
                                        print(passRecipie.wrappedTitle)
                                        showingEditScreen.toggle()
                                    }
                                
                            } else {
                                if recipie.wrappedTitle.lowercased().contains(searchText.lowercased()) {
                                    ListElement(recipie: recipie)
                                        .onTapGesture{
                                            passRecipie = recipie
                                            print(passRecipie.wrappedTitle)
                                            showingEditScreen.toggle()
                                        }
                                    
                                }
                                
                                
                                
                                
                            }
                        }
                    }
                    
                }
                .searchable(text: $searchText)
           
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
                  //  ImportRecipieView()
                }

               .sheet(isPresented: $showingEditScreen){
                   EditRecipieView(rezept: passRecipie)
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
