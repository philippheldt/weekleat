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
    
    @State private var showingAddScreen = false
    @State public var currentLetter = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(recipies) { recipie in

//                        if currentLetter != returnFirstLetter(word: recipie.wrappedTitle) {
//                            Text("\(returnFirstLetter(word: recipie.wrappedTitle))")
//                                .font(.caption)
//                         currentLetter = returnFirstLetter(word: recipie.wrappedTitle)
//                        }
                        
                        ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: [.Veggi, .Schnell], backgroundColor: "BlueLight", portion: Int(recipie.portion))
                            
                    }
                }
                .padding(.horizontal)
                
            }
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
        }
    }
}

struct RezeptSammlung_Previews: PreviewProvider {
    static var previews: some View {
        RezeptSammlung()
    }
}
