//
//  WeekPlannerItems.swift
//  weekleat
//
//  Created by Philipp Jenny on 01.08.22.
//

import SwiftUI

struct WeekPlannerItems: View {
    var recipie: Recipie
    var dayPicked: String
    @Binding var passRecipie: Recipie?
    @Binding var showingEditScreen: Bool
    
    var body: some View {
        if getTodayWeekDay().lowercased() == dayPicked {
            
            VStack(alignment: .leading){
                Text("Heute")
                    .font(.title)
                    .fontWeight(.bold)
                Text(getDates())
                    .textCase(.uppercase)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            ListElementLarge(recipie: recipie)
                .onTapGesture{
                    passRecipie = recipie
                    showingEditScreen.toggle()
                }
                .padding(.bottom)
        } else {
            Text(dayPicked)
                .font(.caption)
                .textCase(.uppercase)
                .foregroundColor(.gray)
                .padding([.leading, .top])
            ListElement(recipie: recipie)
            
                .onTapGesture{
                    passRecipie = recipie
                    showingEditScreen.toggle()
                }
        }
    }
    
    func getTodayWeekDay()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de")
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: Date())
        return weekDay
    }
    
    func getDates()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let dateToday = dateFormatter.string(from: Date())
        return dateToday
    }
}

