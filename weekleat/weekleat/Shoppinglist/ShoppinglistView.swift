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
        NavigationView{
            List{
                Section(header: Text("Offen")){
                    ForEach(shoppingItems, id:\.self) {shoppingItem in
                        if !shoppingItem.bought{
                            ListItemElement(titleText: shoppingItem.title ?? "", titleImage: "pasta", color: .YellowLight, tags: [.Fluid], backgroundColor: "PureWhite", portion: 0)
                                .onTapGesture {
                                    shoppingItem.bought = true
                                    try? moc.save()
                                }
                                .swipeActions(edge: .leading){
                                    Button{
                                        shoppingItem.bought = true
                                        try? moc.save()

                                    } label: {
                                        Label("", systemImage: "checkmark")
                                    }
                                    .tint(Color("YellowLight"))
                                }
                        }
                    
                    }
                }
                Section(header: Text("Gekauft")){
                    ForEach(shoppingItems, id:\.self) {shoppingItem in
                        if shoppingItem.bought{
                            ListItemElement(titleText: shoppingItem.title ?? "", titleImage: "pasta", color: .YellowLight, tags: [.Fluid], backgroundColor: "PureWhite", portion: 0)
                                .onTapGesture {
                                    shoppingItem.bought = false
                                    try? moc.save()
                                }
                                .swipeActions(edge: .leading){
                                    Button{
                                        shoppingItem.bought = false
                                        try? moc.save()

                                    } label: {
                                        Label("", systemImage: "checkmark")
                                    }
                                    .tint(Color("YellowLight"))
                                }
                        }
                    }
                }
            }
            .navigationTitle("Einkaufsliste")
        }
        
    }
}



struct ShoppinglistView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppinglistView()
    }
}
