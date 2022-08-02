//
//  CustomNavLink.swift
//  weekleat
//
//  Created by Philipp Jenny on 29.07.22.
//

import SwiftUI

struct CustomNavLink<Label:View, Destination:View>: View {
    
    let destination: Destination
    let label: Label
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink(
            destination: CustomNavBarContainer(content: {
                destination
            })
            .navigationBarHidden(true)
            , label: {
                label
            })
    }
}

struct CustomNavLink_Previews: PreviewProvider {
    static var previews: some View {
        CustomNav{
            CustomNavLink(
                destination: Text("Hallo123")){
                    Text("Click me!")
                }
        }
        
    }
}
