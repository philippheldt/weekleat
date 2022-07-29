//
//  CustomNavBarContainer.swift
//  weekleat
//
//  Created by Philipp Jenny on 29.07.22.
//

import SwiftUI

struct CustomNavBarContainer<Content: View>: View {
    let content: Content
    @State private var back: Bool = false
    @State private var title: String = ""
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0){
            CustomNavBar(back: true, title: "Wochenplan")
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(CustomNavBarTitlePreferenceKey.self, perform: { value in
            self.title = value
        })
        
        .onPreferenceChange(CustomNavBarBackPreferenceKey.self, perform: { value in
            self.back = value
        })
        
    }
}

struct CustomNavBarContainer_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBarContainer{
            ZStack{
                Color.gray.ignoresSafeArea()
            }
            .customNavigationBack(false)
         
        }
    }
}
