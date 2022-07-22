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
    
    @Environment(\.managedObjectContext) var moc // To be able to write in the Data Model also
    @FetchRequest(sortDescriptors: []) var recipies: FetchedResults<Recipie> //Fetching (just reading Data from the Data Model)
    
    let icons = ["book.closed","note.text","cart","gearshape"]
    let iconsFilled = ["book.closed.fill","square.fill","cart.fill","gearshape.fill"]
    var body: some View {
        VStack{
            ZStack{
                switch selectedIndex {
                case 0: RezeptSammlung()
                case 1: WeekPlanner()
                case 2: ShoppinglistView()
                case 3: SettingsView()
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
                            Image(systemName: iconsFilled[i])
                                .font(.system(size: 30,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(Color("BlueMedium"))
                                .opacity(selectedIndex == i ? 1 : 0)
                        })
                        
                        if i == 1 {
                            Button(action: {
                                self.selectedIndex = i
                            }, label: {
                                Image(systemName: icons[i])
                                    .font(.system(size: 30,
                                                  weight: .regular,
                                                  design: .default))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color("PureWhite"), Color("BlueDark") )
                            })
                        } else {
                            Button(action: {
                                self.selectedIndex = i
                            }, label: {
                                Image(systemName: icons[i])
                                    .font(.system(size: 30,
                                                  weight: .regular,
                                                  design: .default))
                            })
                        }
                        
                        
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
