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
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("RedLight"))
                    .frame(width: 75, height: 75)
                Image("pizza")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 65, height: 65)
            }
            
            
            VStack(alignment: .leading, spacing: 5){
                Text("Rezept")
                    .font(Font.custom("Migra", size: 24))
                HStack{
                    TagView()
                }
            }.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.accentColor)
            } .padding()
            
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .cornerRadius(10)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem()
            .previewLayout(.fixed(width: 400, height: 90))
    }
}
