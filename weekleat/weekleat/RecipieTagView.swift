//
//  TagView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import WrappingHStack
import SwiftUI

struct RecipieTagView: View {
    @Binding var rezept: Rezept
    var tags: [TagIcon]
    var body: some View {
        WrappingHStack{
            
            SingleTagView(iconName: "person.2", color: .BlueDark, backgroundColor: "BlueLight", textContent: String(rezept.portion), amount: 1, detailText: "")
            
        
            
            ForEach(tags, id: \.self){tag in
                
                SingleTagView(iconName: tag.IconOutline, color: .BlueDark, backgroundColor: "BlueLight", textContent: tag.rawValue, amount: tags.count, detailText: "")
        
            }
            
        }
        
        
    }
}


struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        RecipieTagView(rezept:
                .constant(Rezepte.dummyRezepte[1]),
                tags: Rezepte.dummyRezepte[1].tags)
        
        .previewLayout(.sizeThatFits)
    }
}
