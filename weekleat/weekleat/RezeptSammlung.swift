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

    
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(recipies) { recipie in
                    ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: [.Veggi, .Schnell], backgroundColor: "BlueLight", portion: 5)
                        .padding(.horizontal)
                }
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
