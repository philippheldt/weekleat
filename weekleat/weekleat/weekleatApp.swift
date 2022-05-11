//
//  weekleatApp.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

@main
struct weekleatApp: App {
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Migra", size: 38)!]
    }
    var body: some Scene {
        WindowGroup {
            WeekPlanner()
        }
    }
}
