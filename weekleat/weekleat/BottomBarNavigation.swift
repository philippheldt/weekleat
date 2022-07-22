//
//  BottomBarNavigation.swift
//  weekleat
//
//  Created by Philipp Jenny on 23.06.22.
//

import SwiftUI

struct BottomBarNavigation: View {
    @State var selectedIndex = 0
    @State private var rezepte = Rezepte.dummyRezepte
    
    @Environment(\.managedObjectContext) var moc // To be able to write in the Data Model also
    @FetchRequest(sortDescriptors: []) var recipies: FetchedResults<Recipie> //Fetching (just reading Data from the Data Model)
    
    let icons = ["book.closed","note.text","cart","gearshape"]
    let iconsFilled = ["book.closed.fill","square.fill","cart.fill","gearshape.fill"]
    var body: some View {
        TabView{
            RezeptSammlung(passRecipie: recipies[0])
            .tabItem{
                Image(systemName: "book.closed.fill")
            }
            WeekPlanner()
            .tabItem{
                Image(systemName: "note.text")
            }
            ShoppinglistView()
            .tabItem{
                Image(systemName: "cart")
            }
            SettingsView()
            .tabItem{
                Image(systemName: "gearshape")
            }
        }
        
    }
}

struct BottomBarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarNavigation()
    }
}
