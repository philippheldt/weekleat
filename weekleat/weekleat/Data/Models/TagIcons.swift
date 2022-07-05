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
    case Peice = "Fleisch"
    case Potatoe = "Kartoffel"
    case Spoon = "s"
    case Baked = "gebacken"
    case Pasta = "Nudeln"
    case Rice = "Reis"
    
    
    var IconFill: String{
        switch self {
        case .Veggi: return "leaf.fill"
        case .Vegan: return "leaf.fill"
        case .Schnell: return "bolt.fill"
        case .Lang: return "clock.fill"
        case .Weight: return "scalemass.fill"
        case .Fluid: return "clock"
        case .Peice: return "meat.weekleat"
        case .Potatoe: return "potatoe.weekleat.fill"
        case .Spoon: return "testtube.2"
        case .Baked: return "oven.fill"
        case .Pasta: return "pasta.ico.fill"
        case .Rice: return "rice.ico.fill"
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
        case .Peice: return "meat.weekleat"
        case .Potatoe: return "potatoe.weekleat"
        case .Spoon: return "testtube.2"
        case .Baked: return "oven"
        case .Pasta: return "pasta.ico"
        case .Rice: return "rice.ico"
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
