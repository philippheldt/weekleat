//
//  WeekPlannerItems.swift
//  weekleat
//
//  Created by Philipp Jenny on 02.08.22.
//

import SwiftUI

struct WeekPlannerItems: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.picked)]) var recipies: FetchedResults<Recipie>
    
    @AppStorage("montag") private var montag: Bool = true
    @AppStorage("dienstag") private var dienstag: Bool = true
    @AppStorage("mittwoch")  private var mittwoch: Bool = true
    @AppStorage("donnerstag")  private var donnerstag: Bool = true
    @AppStorage("freitag") private var freitag: Bool = true
    @AppStorage("samstag")  private var samstag: Bool = true
    @AppStorage("sonntag")  private var sonntag: Bool = true
    
    @Binding var passRecipie: Recipie?
    @Binding var showingEditScreen: Bool
    @Binding var generatedRecipies: [Recipie]
    

    
    var body: some View {
        VStack(alignment: .leading){
            if recipies.count > 0 {
                ForEach(recipies, id:\.self){ recipie in
                    if recipie.picked == 1 && montag{
                        WeekPlannerSwitch(recipie: recipie, dayPicked: "montag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen, generatedRecipies: $generatedRecipies)
                    }
                    else if recipie.picked == 2 && dienstag{
                        WeekPlannerSwitch(recipie: recipie, dayPicked: "dienstag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen, generatedRecipies: $generatedRecipies)
                    }
                    else if recipie.picked == 3 && mittwoch{
                        WeekPlannerSwitch(recipie: recipie, dayPicked: "mittwoch", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen, generatedRecipies: $generatedRecipies)
                    }
                    else if recipie.picked == 4 && donnerstag{
                        WeekPlannerSwitch(recipie: recipie, dayPicked: "donnerstag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen, generatedRecipies: $generatedRecipies)
                    }
                    else if recipie.picked == 5 && freitag{
                        WeekPlannerSwitch(recipie: recipie, dayPicked: "freitag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen, generatedRecipies: $generatedRecipies)
                    }
                    else if recipie.picked == 6 && samstag{
                        WeekPlannerSwitch(recipie: recipie, dayPicked: "samstag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen, generatedRecipies: $generatedRecipies)
                    }
                    else if recipie.picked == 7 && sonntag{
                        WeekPlannerSwitch(recipie: recipie, dayPicked: "sonntag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen, generatedRecipies: $generatedRecipies)
                    }
                    
                }
                
            }
        }
    }
}


