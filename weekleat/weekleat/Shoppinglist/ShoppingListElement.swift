//
//  ShoppingListElement.swift
//  weekleat
//
//  Created by Philipp Jenny on 01.08.22.
//

import SwiftUI

struct ShoppingListElement: View {
    
        @State var shoppingItem: BuyIngr
        var body: some View {
            VStack{
                HStack{
                    ZStack{
                        Image("backgroundRed")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Image("lasagne")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                    }
                    VStack(alignment: .leading, spacing: 3){
                        Text(shoppingItem.title ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                        HStack{
                            TagView(tagName: "\(Int(shoppingItem.amount)) \(shoppingItem.unit ?? "")", tagIcon: "portion.icon.black")
                        }
                       
                    }.padding(.leading)
                    Spacer()
                }
                
            }
            .cornerRadius(5)
            .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 0.5)
                )
            .padding(.horizontal)
        }
    
}

//struct ShoppingListElement_Previews: PreviewProvider {
//    static var previews: some View {
//        ShoppingListElement()
//    }
//}
