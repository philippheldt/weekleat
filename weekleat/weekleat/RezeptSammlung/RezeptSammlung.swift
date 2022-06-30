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

                    NavigationLink(destination: EditRecipieView(rezept: recipie), label: {
                        if searchText == "" {
                            ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: tagConverter(tagString: recipie.wrappedTags), backgroundColor: "PureWhite", portion: Int(recipie.portion))
                                
                           
                        } else {
                            if recipie.wrappedTitle.lowercased().contains(searchText.lowercased()) {
                                ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: [.Veggi, .Schnell], backgroundColor: "PureWhite", portion: Int(recipie.portion))
                            }
                        }
                    })
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
