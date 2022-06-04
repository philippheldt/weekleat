//
//  ListView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct WeekPlanner: View {
    @Binding var rezepte: [Rezept]
    @State  var showSheet: Bool = false
    var body: some View {
        NavigationView{
            ZStack{
                Color("PureWhite")
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    ForEach($rezepte){ $rezept in
                        ListItemElement(titleText: rezept.title, titleImage: rezept.foodType, color: rezept.colorTheme, tags: rezept.tags, backgroundColor: "BlueLight", portion: rezept.portion)
                            .padding([.leading, .trailing])
                            .onTapGesture {
                                showSheet.toggle()
                            }
                            .swipeActions{
                                Button {
                                    print("Delete")
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .tint(Color("RedLight"))
                            }
                            .swipeActions(edge: .leading){
                                Button {
                                    print("Delete")
                                } label: {
                                    Image(systemName: "suit.heart")
                                }
                                .tint(Color("BlueMedium"))
                            }
                    }
                }.navigationTitle("Wochenplan")
                    .sheet(isPresented: $showSheet, content: {
                        RezeptDetailView()
                    })
            }
            
            
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner(rezepte:
                .constant(Rezepte.dummyRezepte))

    }
}
