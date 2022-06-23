//
//  BottomBarNavigation.swift
//  weekleat
//
//  Created by Philipp Jenny on 23.06.22.
//

import SwiftUI

struct BottomBarNavigation: View {
    @State var selectedIndex = 0
    @State private var rezepte = Rezepte.dummyRezepte
    let icons = ["book.closed","note.text","cart","gearshape"]
    let iconsFilled = ["book.closed.fill","square.fill","cart.fill","gearshape.fill"]
    var body: some View {
        VStack{
            ZStack{
                switch selectedIndex {
                case 0: Text("Rezeptsammlung")
                case 1: WeekPlanner(rezepte: $rezepte)
                case 2: Text("Einkaufsliste")
                case 3: Text("Einstellungen")
                default: Text("Rezeptsammlung")
                }
            }
            
            Spacer()
            
            
            HStack{
                Spacer()
                ForEach(0..<4, id: \.self){ i in
                    ZStack{
                        Button(action: {
                            self.selectedIndex = i
                        }, label: {
                            Image(systemName: selectedIndex == i ? iconsFilled[i] : "")
                                .font(.system(size: 30,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(Color("BlueMedium"))
                        })
                        
                        Button(action: {
                            self.selectedIndex = i
                        }, label: {
                            Image(systemName: icons[i])
                                .font(.system(size: 30,
                                              weight: .regular,
                                              design: .default))
                        })
                        
                    }
                   
                    Spacer()
                }
                

            }
            .padding()

            
        }
     
    }
}

struct BottomBarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarNavigation()
    }
}
