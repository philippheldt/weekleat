//
//  TagView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import WrappingHStack
import SwiftUI

struct TagView: View {
    @Binding var rezept: Rezept
    var body: some View {
        WrappingHStack{
            HStack{
                ZStack{
                    Image(systemName: "person.2.fill")
                        .foregroundColor(Color(rezept.colorTheme.lightColor))
                        .font(.system(size: 13))
                    Image(systemName: "person.2")
                        .foregroundColor(Color(rezept.colorTheme.darkColor))
                        .font(.system(size: 13))
                }
                Text(String(rezept.portion))
                    .font(.system(size: 13))
                    .foregroundColor(Color(rezept.colorTheme.darkColor))
            }
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            .background(Color("BlueLight"))
            .cornerRadius(50)
            
            HStack{
                ZStack{
                    Image(systemName: "person.2.fill")
                        .foregroundColor(Color(rezept.colorTheme.lightColor))
                        .font(.system(size: 13))
                    Image(systemName: "person.2")
                        .foregroundColor(Color(rezept.colorTheme.darkColor))
                        .font(.system(size: 13))
                }
                Text("Huuuuuuhuuuuu")
                    .font(.system(size: 13))
                    .foregroundColor(Color(rezept.colorTheme.darkColor))
            }
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            .background(Color("BlueLight"))
            .cornerRadius(50)
        }
        
        
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(rezept:
                .constant(Rezepte.dummyRezepte[1]))
        .previewLayout(.sizeThatFits)
    }
}
