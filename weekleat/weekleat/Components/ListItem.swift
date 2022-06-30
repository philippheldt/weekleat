//
//  ListItem.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct ListItem: View {
    @State var rezept: Rezept
    @Binding var showSheet: Bool
    
    var body: some View {
        HStack {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(rezept.colorTheme.rawValue))
                    .frame(width: 75, height: 75)
                Image(rezept.foodType)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 65, height: 65)
            }
            
            
            VStack(alignment: .leading, spacing: 5){
                Text(rezept.title)
                    .font(Font.custom("Migra", size: 21))
                    .foregroundColor(.accentColor)
                HStack{
                    RecipieTagView(rezept: $rezept, tags: rezept.tags)
                    
                }
            }.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
            
            Spacer()
            
            Button(action: {
                showSheet.toggle()
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.accentColor)
            } .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .cornerRadius(10)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(rezept: Rezepte.dummyRezepte[2], showSheet: .constant(false))
            .previewLayout(.fixed(width: 400, height: 90))
    }
}
