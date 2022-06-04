//
//  RezeptDetailView.swift
//  weekleat
//
//  Created by Philipp Jenny on 25.05.22.
//

import SwiftUI
import WrappingHStack

struct RezeptDetailView: View {
    var sampleTags: [String] = ["5 Portionen", "schnell", "veggi", "pasta", "lecker", "liebling", "5", "Anderer Tag Name"]
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
                        WrappingHStack(sampleTags, id: \.self){tag in
                            SingleTagView(iconName: "person.2", color: .BlueDark, backgroundColor: "PureWhite", textContent: tag, amount: 1)
                        }

                    }
                    .padding([.leading, .trailing])
                    ZStack{
                        Color("PureWhite")
                            .edgesIgnoringSafeArea(.all)
                        ScrollView{
                            VStack{
                                ListItemElement(titleText: "Nudeln", titleImage: "pasta", color: .YellowLight, tags: [.Schnell], backgroundColor: "BlueLight", portion: 0)
                                Spacer()
                            }
                            .padding([.leading, .top, .trailing])
                        }
                      
                        
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Rezept")
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
        RezeptDetailView()
    }
}
