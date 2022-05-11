//
//  TagView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct TagView: View {
    var body: some View {
        HStack{
            ZStack{
                Image(systemName: "person.2.fill")
                    .foregroundColor(Color("RedLight"))
                Image(systemName: "person.2")
                    .foregroundColor(Color("RedDark"))
            }
            Text("5")
                .foregroundColor(Color("RedDark"))
        }
        .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
        .background(Color("BlueLight"))
        .cornerRadius(50)
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
            .previewLayout(.sizeThatFits)
    }
}
