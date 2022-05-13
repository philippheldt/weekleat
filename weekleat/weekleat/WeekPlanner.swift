//
//  ListView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct WeekPlanner: View {
    @Binding var rezepte: [Rezept]
    var body: some View {
        NavigationView{
            
            List() {
                ForEach($rezepte){ $rezept in
                ListItem(rezept: rezept)
                }
            }.navigationTitle("Wochenplan")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner(rezepte:
                .constant(Rezepte.dummyRezepte))

    }
}
