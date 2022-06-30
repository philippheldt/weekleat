//
//  TagConverter.swift
//  weekleat
//
//  Created by Philipp Jenny on 29.06.22.
//

import Foundation

func tagConverter(tagString: String) -> [TagIcon] {
    let tags: [String] = tagString.components(separatedBy: ",")
    var tagsConverted: [TagIcon] = []
    for tag in tags {
        switch tag {
        case "vegetarisch": tagsConverted.append(.Veggi)
        case "vegan": tagsConverted.append(.Vegan)
        case "Kartoffeln": tagsConverted.append(.Potatoe)
        case "Nudeln": tagsConverted.append(.Fluid)
        case "Reis": tagsConverted.append(.Peice)
        case "Salat": tagsConverted.append(.Veggi)
        case "schnell": tagsConverted.append(.Schnell)
        case "gebacken": tagsConverted.append(.Weight)
        case "aufwändig": tagsConverted.append(.Lang)
        default: tagsConverted.append(.Peice)
        }
    }
    
    return tagsConverted
}
