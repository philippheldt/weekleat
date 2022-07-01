//
//  ListItemElement.swift
//  weekleat
//
//  Created by Philipp Jenny on 03.06.22.
//

import SwiftUI

struct ShoppingListItem: View {
        var titleText: String
        var titleImage: String
        var color: ColorTheme
        var amount: Float
        var unit: String
        var bought: Bool

        
    init(titleText: String, titleImage: String, color: ColorTheme, amount: Float, unit: String, bought: Bool){
            self.titleText = titleText
            self.titleImage = titleImage
            self.color = color
            self.amount = amount
            self.unit = unit
            self.bought = bought

        }
    var body: some View {
        
        if bought{
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
//                            SingleTagViewButton(iconName: "", color: color, backgroundColor: color.rawValue, textContent: "\(amount) \(unit)", amount: 1, active: true)
                            SingleTagViewButton(iconName: "circlebadge.2", color: color, backgroundColor: color.rawValue, textContent: "\((round(amount * 100)/100.0).clean) \(unit)", amount: 1, active: true)
                        }
                    }.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
                    
                    Spacer()
                    
                    
                    
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
              //  .background(Color(backgroundColor))
            }
            .cornerRadius(10)
    .saturation(0)

        } else {
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
                            SingleTagViewButton(iconName: "circlebadge.2", color: color, backgroundColor: color.rawValue, textContent: "\((round(amount * 100)/100.0).clean) \(unit)", amount: 1, active: true)
                        }
                    }.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
                    
                    Spacer()
                    
                    
                    
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
              //  .background(Color(backgroundColor))
            }
            .cornerRadius(10)
        }
        
       
    }
    
}

//
//struct ShoppingListItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ListItemElement(titleText: "Rezpettitel", titleImage: "pizza", color: .RedLight, tags: [.Veggi, .Schnell], backgroundColor: "BlueLight", portion: 5)
//            .previewLayout(.fixed(width: 400, height: 90))
//    }
//}
