//
//  TagView.swift
//  weekleat
//
//  Created by Philipp Jenny on 28.07.22.
//

import SwiftUI

struct TagSingle: View {
    var body: some View {
        HStack{
            Image("rice.icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
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

struct TagSingle_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
            .previewLayout(.sizeThatFits)
    }
}
