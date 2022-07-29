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
    @StateObject private var dataController = DataController()
 
    
    var body: some Scene {
        WindowGroup {
            WeekPlanner()
                .environment(\.managedObjectContext, dataController.container.viewContext) //Adding Data to Memory (Not writing it on the Disk yet)
        }
    }
}
