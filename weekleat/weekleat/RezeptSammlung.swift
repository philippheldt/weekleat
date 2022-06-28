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
    @State private var searchText = ""
    
    
    var body: some View {
        NavigationView{
                List(recipies) {recipie in

//                        if currentLetter != returnFirstLetter(word: recipie.wrappedTitle) {
//                            Text("\(returnFirstLetter(word: recipie.wrappedTitle))")
//                                .font(.caption)
//                         currentLetter = returnFirstLetter(word: recipie.wrappedTitle)
//                        }
                    if searchText == "" {
                        ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: [.Veggi, .Schnell], backgroundColor: "PureWhite", portion: Int(recipie.portion))
                    } else {
                        if recipie.wrappedTitle.lowercased().contains(searchText.lowercased()) {
                            ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: [.Veggi, .Schnell], backgroundColor: "PureWhite", portion: Int(recipie.portion))
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
        }
    }
}

struct RezeptSammlung_Previews: PreviewProvider {
    static var previews: some View {
        RezeptSammlung()
    }
}
