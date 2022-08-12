//
//  ListElement.swift
//  weekleat
//
//  Created by Philipp Jenny on 28.07.22.
//

import SwiftUI

struct ListElement: View {
    @State var recipie: Recipie
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            HStack{
                ZStack{
                    Image(chooseImages(title: recipie.wrappedTitle))
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                VStack(alignment: .leading, spacing: 3){
                    Text(recipie.wrappedTitle)
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(1)
                         .truncationMode(.tail)
                    HStack{
                        TagView(tagName: String(recipie.portion), tagIcon: colorScheme == .dark ? "portion.icon.white" : "portion.icon.black")
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
        .background(Color(UIColor.systemBackground))
        .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 0.5)
            )
        .padding(.horizontal)
    }
}

//struct ListElement_Previews: PreviewProvider {
//    static var previews: some View {
//        ListElement()
//            .previewLayout(.sizeThatFits)
//    }
//}
