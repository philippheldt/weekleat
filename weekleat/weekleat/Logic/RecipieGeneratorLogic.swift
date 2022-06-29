//
//  RecipieGeneratorLogic.swift
//  weekleat
//
//  Created by Philipp Jenny on 29.06.22.
//

import Foundation

func numberOfRecepies(amount: String, days: Int) -> Int {
    var number: Int = 0
    if days > 5{
        switch amount {
            case "häufig": number = 3
            case "mittel": number = 2
            case "selten": number = 1
            default: number = 1
        }
    } else if number <= 5{
        switch amount {
            case "häufig": number = 2
            case "mittel": number = 1
            case "selten": number = 1
            default: number = 1
        }
    }
    return number
    
}

func daysCount(montag: Bool, dienstag: Bool, mittwoch: Bool, donnerstag: Bool, freitag: Bool, samstag: Bool, sonntag: Bool) -> Int {
    var count: Int = 0
    if montag {
        count += 1
    }
    if dienstag {
        count += 1
    }
    if mittwoch {
        count += 1
    }
    if donnerstag {
        count += 1
    }
    if freitag {
        count += 1
    }
    if samstag{
        count += 1
    }
    if sonntag {
        count += 1
    }
    return count
    
}


func daysArray(montag: Bool, dienstag: Bool, mittwoch: Bool, donnerstag: Bool, freitag: Bool, samstag: Bool, sonntag: Bool) -> [String] {
    var count: [String] = []
    if montag {
        count.append("Montag")
    }
    if dienstag {
        count.append("Dienstag")
    }
    if mittwoch {
        count.append("Mittwoch")
    }
    if donnerstag {
        count.append("Donnerstag")
    }
    if freitag {
        count.append("Freitag")
    }
    if samstag{
        count.append("Samstag")
    }
    if sonntag {
        count.append("Sonntag")
    }
    return count
    
}



