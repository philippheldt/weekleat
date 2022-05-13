//
//  ColorTheme.swift
//  weekleat
//
//  Created by Philipp Jenny on 12.05.22.
//

import Foundation

enum ColorTheme: String, CaseIterable{
    case YellowLight = "YellowLight"
    case YellowMedium = "YellowMedium"
    case YellowDark = "YellowDark"
    case RedLight = "RedLight"
    case RedMedium = "RedMedium"
    case RedDark = "RedDark"
    case BlueLight = "BlueLight"
    case BlueMedium = "BlueMedium"
    case BlueDark = "BlueDark"
    
    var darkColor: String{
        switch self {
            case .YellowLight, .YellowMedium, .YellowDark: return "YellowDark"
            case .RedLight, .RedMedium, .RedDark: return "RedDark"
            case .BlueLight, .BlueMedium, .BlueDark: return "BlueDark"
        }
    }
    
    var mediumColor: String{
        switch self {
            case .YellowLight, .YellowMedium, .YellowDark: return "YellowMedium"
            case .RedLight, .RedMedium, .RedDark: return "RedMedium"
            case .BlueLight, .BlueMedium, .BlueDark: return "BlueMedium"
        }
    }
    
    var lightColor: String{
        switch self {
            case .YellowLight, .YellowMedium, .YellowDark: return "YellowLight"
            case .RedLight, .RedMedium, .RedDark: return "RedLight"
            case .BlueLight, .BlueMedium, .BlueDark: return "BlueMedium"
        }
    }
}

