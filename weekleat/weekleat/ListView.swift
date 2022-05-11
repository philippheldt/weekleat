//
//  ListView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct WeekPlanner: View {
    var body: some View {
        List {
            ListItem()
            ListItem()
            ListItem()
            ListItem()
            ListItem()
            ListItem()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner()

    }
}
