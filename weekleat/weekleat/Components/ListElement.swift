//
//  ListElement.swift
//  weekleat
//
//  Created by Philipp Jenny on 28.07.22.
//

import SwiftUI

struct ListElement: View {
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
                    Text("Lasagne")
                        .font(.title2)
                        .fontWeight(.bold)
                    TagView()
                }.padding(.leading)
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(Font.system(size: 15, weight: .light))
                    .foregroundColor(.gray)
                    .padding()
            }
            
        }
        .cornerRadius(5)
        .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 0.5)
            )
        .padding(.vertical)
    }
}

struct ListElement_Previews: PreviewProvider {
    static var previews: some View {
        ListElement()
            .previewLayout(.sizeThatFits)
    }
}
