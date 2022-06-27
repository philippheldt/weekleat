//
//  RezeptDetailView.swift
//  weekleat
//
//  Created by Philipp Jenny on 25.05.22.
//

import SwiftUI
import WrappingHStack
import Foundation

struct RezeptDetailView: View {

    var rezeptDetails: Rezept
    var body: some View {
        NavigationView{
            ZStack {
                Color("BlueLight")
                    .edgesIgnoringSafeArea([.leading, .top, .trailing])
                VStack{
                    Text("Kategorien")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("Gray"))
                        .padding([.leading, .top, .trailing])
                    WrappingHStack{
                        WrappingHStack(rezeptDetails.tags, id: \.self){tag in
                            SingleTagView(iconName: tag.IconOutline, color: rezeptDetails.colorTheme, backgroundColor: "PureWhite", textContent: tag.rawValue, amount: 1, active: false)
                        }

                    }
                    .padding([.leading, .trailing])
                    ZStack{
                        Color("PureWhite")
                            .edgesIgnoringSafeArea(.all)
                        ScrollView{
                            VStack{
                                ForEach(rezeptDetails.ingredients, id: \.id ){ ingredient in
                                    ListItemElement(titleText: "\(ingredient.title)", titleImage: "pasta", color: rezeptDetails.colorTheme, tags: [ingredient.tag], backgroundColor: "BlueLight", portion: 0)
                                }
                                Spacer()
                            }
                            .padding([.leading, .top, .trailing])
                        }
                      
                        
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(rezeptDetails.title)
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        
                    }, label: {
                        Text("Abbrechen")
                    })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        
                    }, label: {
                        Text("Speichern")
                    })
                }
            }
        }
    }
}

struct RezeptDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RezeptDetailView(rezeptDetails: Rezepte.dummyRezepte[1])
    }
}
