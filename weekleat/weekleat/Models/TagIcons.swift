//
//  TagIcons.swift
//  weekleat
//
//  Created by Philipp Jenny on 25.05.22.
//

import Foundation

enum TagIcon: String, CaseIterable{
    case Veggi = "veggi"
    case Vegan = "vegan"
    case Schnell = "schnell"
    case Lang = "lang"
    
    var IconFill: String{
        switch self {
            case .Veggi: return "leaf.fill"
            case .Vegan: return "leaf.fill"
            case .Schnell: return "bolt.fill"
            case .Lang: return "clock.fill"
        }
    }
    var IconOutline: String{
        switch self {
            case .Veggi: return "leaf"
            case .Vegan: return "leaf"
            case .Schnell: return "bolt"
            case .Lang: return "clock"
        }
    }
}
