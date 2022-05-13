//
//  weekleatApp.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

@main
struct weekleatApp: App {
    @State private var rezepte = Rezepte.dummyRezepte
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Migra", size: 38)!]
    }
    var body: some Scene {
        WindowGroup {
            WeekPlanner(rezepte: $rezepte)
        }
    }
}
