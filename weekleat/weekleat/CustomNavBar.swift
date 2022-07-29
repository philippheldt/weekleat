//
//  CustomNavBar.swift
//  weekleat
//
//  Created by Philipp Jenny on 29.07.22.
//

import SwiftUI

struct CustomNavBar: View {
    @Environment(\.presentationMode) var presentationMode
   let back: Bool
    let title: String
    
    var body: some View {
        VStack{
            HStack{
                if back == true {
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    }label:{
                        Image("arrow.left.black")
                        Text(title)
                            .font(.subheadline)
                    }
                    Spacer()
                } else {
           
                   
                }
               
             
            
              
            }
            .padding()
            Divider()
                .background(Color.gray)
        }
        .background(
            Color.white.ignoresSafeArea(edges: .top)
        )
     
    }
}

struct CustomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CustomNavBar(back: true, title: "Wochenplan")
                Spacer()
        }
   
    }
}
