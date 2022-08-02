//
//  ShoppinglistView.swift
//  weekleat
//
//  Created by Philipp Jenny on 30.06.22.
//

import SwiftUI




struct ShoppinglistView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var recipies: FetchedResults<Recipie>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var shoppingItems: FetchedResults<BuyIngr>
    
    var body: some View {
        CustomNavBarContainer{
            ScrollView {
                VStack(alignment: .leading){
                    Text("Einkaufsliste")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding([.leading, .top])
                    Text("Offen")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.gray)
                        .padding([.leading, .top])
                        ForEach(shoppingItems, id:\.self) {shoppingItem in
                            if !shoppingItem.bought{
                               ShoppingListElement(shoppingItem: shoppingItem)
                                    .onTapGesture {
                                        withAnimation{
                                            shoppingItem.bought = true
                                            try? moc.save()
                                        }
                                        
                                    }
                                    .swipeActions(edge: .leading){
                                        Button{
                                            withAnimation{
                                            shoppingItem.bought = true
                                            try? moc.save()
                                            }
                                        } label: {
                                            Label("", systemImage: "checkmark")
                                        }
                                        .tint(Color("YellowLight"))
                                    }
                            }
                        
                        
                    }
                    Text("gekauft")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.gray)
                        .padding([.leading, .top])
                        ForEach(shoppingItems, id:\.self) {shoppingItem in
                            if shoppingItem.bought{
                                ShoppingListElement(shoppingItem: shoppingItem)
                                    .saturation(0)
                                    .onTapGesture {
                                        withAnimation{
                                            shoppingItem.bought = false
                                            try? moc.save()
                                        }
                                  
                                   
                                    }
                                    .swipeActions(edge: .leading){
                                        Button{
                                            withAnimation{
                                                shoppingItem.bought = false
                                                try? moc.save()
                                            }                                    } label: {
                                            Label("", systemImage: "arrow.uturn.left")
                                        }
                                        .tint(.gray)
                                        
                                    }
                            
                        }
                    }
                }
            
               
            }
            .listStyle(.sidebar)
            .navigationBarHidden(true)
        }
        
    }
}



struct ShoppinglistView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppinglistView()
    }
}
