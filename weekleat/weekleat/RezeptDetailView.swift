//
//  RezeptDetailView.swift
//  weekleat
//
//  Created by Philipp Jenny on 25.05.22.
//

import SwiftUI

struct RezeptDetailView: View {
    var body: some View {
        NavigationView{
            VStack{
                
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
