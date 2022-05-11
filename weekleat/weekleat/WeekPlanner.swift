//
//  ListView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct WeekPlanner: View {
    var body: some View {
        NavigationView{
            
            List(0..<7) { item in
                ListItem()
            }.navigationTitle("Wochenplan")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner()

    }
}
