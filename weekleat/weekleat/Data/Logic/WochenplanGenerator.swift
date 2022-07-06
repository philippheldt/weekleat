//
//  WochenplanGenerator.swift
//  weekleat
//
//  Created by Philipp Jenny on 28.06.22.
//

import Foundation

func alreadyExsists(itemame:String) -> Bool{
    switch itemame{
    case " Salz"," Pfeffer"," Paprikapulver"," Currypulver"," Knoblauchzehe"," Knoblauch"," Zwiebel"," Zwiebeln"," Chillipulver"," Kreuzkümmel"," Kurkuma"," Muskat": return true
    default: return false
    }
}

