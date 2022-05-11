//
//  ListItem.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct ListItem: View {
    var body: some View {
        HStack {
            Image("pizza")
            VStack{
                Text("Rezept")
                    .font(.title2)
                HStack{
                    
                }
            }
            
        }
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem()
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
