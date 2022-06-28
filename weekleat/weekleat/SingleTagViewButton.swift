//
//  SingleTagView.swift
//  weekleat
//
//  Created by Philipp Jenny on 02.06.22.
//

import SwiftUI

struct SingleTagViewButton: View {
    var iconName: String
    var color: ColorTheme
    var backgroundColor: String
    var textContent: String
    var amount: Int
    var active: Bool
    
    init(iconName: String, color: ColorTheme, backgroundColor: String, textContent: String, amount: Int, active: Bool){
        self.iconName = iconName
        self.color = color
        self.backgroundColor = backgroundColor
        self.textContent = textContent
        self.amount = amount
        self.active = active
    }
    var body: some View {
        

            HStack{
                ZStack{
                    Image(systemName: "\(iconName).fill")
                        .foregroundColor(Color(active == true ? "PureWhite" : "PureWhite"))
                        .font(.system(size: 13))
                        .opacity(0.25)
                    Image(systemName: iconName)
                        .foregroundColor(Color(active == true ? "PureWhite" : "PureWhiteDarker"))
                        .font(.system(size: 13))
                }
                Text(textContent)
                    .font(.system(size: 13))
                    .foregroundColor(Color(active == true ? "PureWhite" : "PureWhiteDarker"))
            }
            .padding(EdgeInsets(top: 2, leading: 5, bottom:2, trailing: 5))
            .background(Color(active == true ? color.lightColor : "BlueLight"))
            .cornerRadius(50)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
  
       
        
        
        
    }
}

struct SingleTagViewButton_Previews: PreviewProvider {
    static var previews: some View {
        SingleTagView(iconName: "person.2", color: .RedDark, backgroundColor: "BlueLight", textContent: "Tap on Button", amount: 1, active: true)
            .previewLayout(.sizeThatFits)
    }
}
