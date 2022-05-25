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
    var tags: [TagIcon]
    var body: some View {
        WrappingHStack{
            HStack{
                ZStack{
                    Image(systemName: "person.2.fill")
                        .foregroundColor(Color("BlueDark"))
                        .font(.system(size: 13))
                    //  Image(systemName: "person.2")
                    //      .foregroundColor(Color(rezept.colorTheme.darkColor))
                    //      .font(.system(size: 13))
                }
                Text(String(rezept.portion))
                    .font(.system(size: 13))
                    .foregroundColor(Color("BlueDark"))
            }
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            .background(Color("BlueLight"))
            .cornerRadius(50)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: -3))
            
            ForEach(tags, id: \.self){tag in
                
                if tags.count < 2{
                    HStack{
                        ZStack{
                            Image(systemName: "\(tag.IconFill)")
                                .foregroundColor(Color("BlueDark"))
                                .font(.system(size: 13))
                            //    Image(systemName: "\(tag.IconOutline)")
                            //        .foregroundColor(Color(rezept.colorTheme.darkColor))
                            //        .font(.system(size: 13))
                        }
                        if tags.count < 2{
                            Text("\(tag.rawValue)")
                                .font(.system(size: 13))
                                .foregroundColor(Color("BlueDark"))
                        }
                        
                    }
                    .padding(EdgeInsets(top: 2, leading: tags.count > 1 ? 2 : 10, bottom: 2, trailing: tags.count > 1 ? 2 : 10))
                    
                    .background(Color("BlueLight"))
                    .cornerRadius(50)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))
                    
                } else {
                    HStack{
                        ZStack{
                            Image(systemName: "\(tag.IconFill)")
                                .foregroundColor(Color("BlueDark"))
                                .font(.system(size: 13))
                            //    Image(systemName: "\(tag.IconOutline)")
                            //        .foregroundColor(Color(rezept.colorTheme.darkColor))
                            //        .font(.system(size: 13))
                        }
                    }
                    .padding(EdgeInsets(top: 2, leading: tags.count > 1 ? 2 : 10, bottom: 2, trailing: tags.count > 1 ? 2 : 10))
                    .frame(width: 20, height: 20)
                    .background(Color("BlueLight"))
                    .cornerRadius(50)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))
                }
                
                
            }
            
        }
        
        
    }
}


struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(rezept:
                .constant(Rezepte.dummyRezepte[1]),
                tags: Rezepte.dummyRezepte[1].tags)
        
        .previewLayout(.sizeThatFits)
    }
}
