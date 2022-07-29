//
//  CustomNavBarPreference.swift
//  weekleat
//
//  Created by Philipp Jenny on 29.07.22.
//

import Foundation
import SwiftUI

//@State public var back: Bool = true
//@State public var backName: String = "zum Wochenplan"

struct CustomNavBarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct CustomNavBarBackPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = true
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}


extension View {
    func customNavigationTitle(_ title: String) -> some View {
        preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
    }
    
    func customNavigationBack(_ back: Bool) -> some View {
        preference(key: CustomNavBarBackPreferenceKey.self, value: back)
    }
    
    func customNavbarItems(title: String = "", back: Bool = true) -> some View{
        self
            .customNavigationTitle(title)
            .customNavigationBack(back)
    }
}
