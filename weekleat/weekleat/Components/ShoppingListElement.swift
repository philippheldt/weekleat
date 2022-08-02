//
//  ShoppingListElement.swift
//  weekleat
//
//  Created by Philipp Jenny on 02.08.22.
//

import SwiftUI

struct ShoppingListElement: View {

        @State var recipie: Recipie
        
        var body: some View {
            HStack{
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
                        Text(recipie.wrappedTitle)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)
                             .truncationMode(.tail)
                        HStack{
                            TagView(tagName: String(recipie.portion), tagIcon: "portion.icon.black")
                            ForEach(recipie.wrappedTags.components(separatedBy: ","), id: \.self){ tag in
                                TagSingle(tagIcon: "")
                            }
                        }
                       
                    }.padding(.leading)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .font(Font.system(size: 15, weight: .light))
                        .foregroundColor(.gray)
                        .padding()
                }
                
            }
            .cornerRadius(5)
            .background(Color.white)
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
