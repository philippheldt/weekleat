//
//  CustomNav.swift
//  weekleat
//
//  Created by Philipp Jenny on 29.07.22.
//

import SwiftUI

struct CustomNav<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            CustomNavBarContainer{
                content
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
       
    }
}

struct CustomNav_Previews: PreviewProvider {
    static var previews: some View {
        CustomNav{
            Color.red.ignoresSafeArea()
        }
    }
}
