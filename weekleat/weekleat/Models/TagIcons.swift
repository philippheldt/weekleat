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
    case Weight = "w"
    case Fluid = "f"
    case Peice = "p"
    case Potatoe = "Kartoffel"
    case Spoon = "s"
    
    
    var IconFill: String{
        switch self {
        case .Veggi: return "leaf.fill"
        case .Vegan: return "leaf.fill"
        case .Schnell: return "bolt.fill"
        case .Lang: return "clock.fill"
        case .Weight: return "scalemass.fill"
        case .Fluid: return "clock"
        case .Peice: return "circlebadge.2.fill"
        case .Potatoe: return "circlebadge.2.fill"
        case .Spoon: return "testtube.2"
        }
    }
    var IconOutline: String{
        switch self {
        case .Veggi: return "leaf"
        case .Vegan: return "leaf"
        case .Schnell: return "bolt"
        case .Lang: return "clock"
        case .Weight: return "scalemass"
        case .Fluid: return "clock"
        case .Peice: return "circlebadge.2"
        case .Potatoe: return "circlebadge.2"
        case .Spoon: return "testtube.2"
        }
    }
}

struct Tag: Identifiable {
    var id: UUID
    var name: String
    var isActive: Bool
    var index: Int
    init(id: UUID = UUID(), name: String, isActive: Bool, index: Int){
        self.id = id
        self.name = name
        self.isActive = isActive
        self.index = index
    }
}
