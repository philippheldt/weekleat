//
//  ListView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct WeekPlanner: View {
    @Binding var rezepte: [Rezept]
    @State var showSheet: Bool = false
    @State var selected: Rezept = Rezepte.dummyRezepte[0]
    var body: some View {
        NavigationView{
          
            
            List{
                Text
            }
                .navigationTitle("Wochenplan")
                    .sheet(isPresented: $showSheet, content: {
                        RezeptDetailView(rezeptDetails: selected)
                    })
        
            
            
            
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner(rezepte:
                .constant(Rezepte.dummyRezepte))

    }
}
