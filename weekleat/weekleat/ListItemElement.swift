//
//  ListItemElement.swift
//  weekleat
//
//  Created by Philipp Jenny on 03.06.22.
//

import SwiftUI

struct ListItemElement: View {
        var titleText: String
        var titleImage: String
        var color: ColorTheme
        var tags: [TagIcon]
        var backgroundColor: String
        var portion: Int

        
    init(titleText: String, titleImage: String, color: ColorTheme, tags: [TagIcon], backgroundColor: String, portion: Int){
            self.titleText = titleText
            self.titleImage = titleImage
            self.color = color
            self.tags = tags
            self.backgroundColor = backgroundColor
            self.portion = portion

        }
    var body: some View {
        HStack{
            HStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(color.rawValue))
                        .frame(width: 75, height: 75)
                    Image(titleImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 65, height: 65)
                }
                
                
                VStack(alignment: .leading, spacing: 5){
                    Text(titleText)
                        .font(Font.custom("Migra", size: 21))
                        .foregroundColor(.accentColor)
                    HStack{
                        if portion > 0 {
                            SingleTagView(iconName: "person.2", color: color, backgroundColor: backgroundColor == "PureWhite" ? "BlueLight" : "PureWhite", textContent: String(portion), amount: 1)
                        }
                        ForEach(tags, id: \.self){tag in
                            SingleTagView(iconName: tag.IconOutline, color: color, backgroundColor: backgroundColor == "PureWhite" ? "BlueLight" : "PureWhite", textContent: tag.rawValue, amount: tags.count)
                        }
                      
                        
                    }
                }.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
                
                Spacer()
                
                Button(action: {
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.accentColor)
                } .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(Color(backgroundColor))
        }
        .cornerRadius(10)
       
    }
    
}


struct ListItemElement_Previews: PreviewProvider {
    static var previews: some View {
        ListItemElement(titleText: "Rezpettitel", titleImage: "pizza", color: .RedLight, tags: [.Veggi, .Schnell], backgroundColor: "BlueLight", portion: 5)
            .previewLayout(.fixed(width: 400, height: 90))
    }
}
