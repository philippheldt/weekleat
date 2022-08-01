//
//  TagView.swift
//  weekleat
//
//  Created by Philipp Jenny on 28.07.22.
//

import SwiftUI

struct TagView: View {
    @State var tagName: String
    @State var tagIcon: String
    
    var body: some View {
        HStack{
            Image(tagIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
            Text(tagName)
                .font(.system(size: 12))
        }

        .padding(3.5)
        .background(.black.opacity(0.05))
        .cornerRadius(5)
        .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 0.5)
                   
            )
    }
}

//struct TagView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagView()
//            .previewLayout(.sizeThatFits)
//    }
//}
