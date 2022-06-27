//
//  SingleTagView.swift
//  weekleat
//
//  Created by Philipp Jenny on 02.06.22.
//

import SwiftUI

struct SingleTagView: View {
    var iconName: String
    var color: ColorTheme
    var backgroundColor: String
    var textContent: String
    var amount: Int
    
    init(iconName: String, color: ColorTheme, backgroundColor: String, textContent: String, amount: Int){
        self.iconName = iconName
        self.color = color
        self.backgroundColor = backgroundColor
        self.textContent = textContent
        self.amount = amount
    }
    var body: some View {
        
        if amount < 2 {
            HStack{
                ZStack{
                    Image(systemName: "\(iconName).fill")
                        .foregroundColor(Color(color.lightColor))
                        .font(.system(size: 13))
                    Image(systemName: iconName)
                        .foregroundColor(Color(color.darkColor))
                        .font(.system(size: 13))
                }
                Text(textContent)
                    .font(.system(size: 13))
                    .foregroundColor(Color(color.darkColor))
            }
            .padding(EdgeInsets(top: 2, leading: 5, bottom:2, trailing: 5))
            .background(Color(backgroundColor))
            .cornerRadius(50)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        } else {
            HStack{
                ZStack{
                    Image(systemName: "\(iconName).fill")
                        .foregroundColor(Color(color.lightColor))
                        .font(.system(size: 13))
                    Image(systemName: iconName)
                        .foregroundColor(Color(color.darkColor))
                        .font(.system(size: 13))
                }

            }
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            .frame(width: 20, height: 20)
            .background(Color(backgroundColor))
            .cornerRadius(50)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        }
        
       
        
        
        
    }
}

struct SingleTagView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTagView(iconName: "person.2", color: .RedDark, backgroundColor: "BlueLight", textContent: "D", amount: 1)
            .previewLayout(.sizeThatFits)
    }
}
