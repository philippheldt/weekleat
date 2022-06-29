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
                        ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: tagConverter(tagString: recipie.wrappedTags), backgroundColor: "PureWhite", portion: Int(recipie.portion))
                            .onTapGesture{
                                showingAddScreen.toggle()
                                
                            }
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
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            for i in recipies{
                                if i.picked > 0{
                                    print("\(i.wrappedTitle): \(i.picked)")
                                }
                                }
                                
                           
                        } label: {
                            Label("", systemImage: "arrow.triangle.2.circlepath")
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
