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
                            ShoppingListItem(titleText: shoppingItem.title ?? "", titleImage: chooseImages(title: (shoppingItem.title ?? "drei")), color: .YellowLight, amount: Int(shoppingItem.amount), unit: shoppingItem.unit ?? "", bought: shoppingItem.bought)
                                .onTapGesture {
                                    shoppingItem.bought = true
                                    try? moc.save()
                                    print(shoppingItem.title ?? "")
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
                            ShoppingListItem(titleText: shoppingItem.title ?? "", titleImage: chooseImages(title: shoppingItem.title ?? ""), color: .YellowLight, amount: Int(shoppingItem.amount), unit: shoppingItem.unit ?? "", bought: shoppingItem.bought)
        
                                .onTapGesture {
                                    shoppingItem.bought = false
                                    try? moc.save()
                                    print(shoppingItem.title ?? "")
                                }
                                .swipeActions(edge: .leading){
                                    Button{
                                        shoppingItem.bought = false
                                        try? moc.save()

                                    } label: {
                                        Label("", systemImage: "arrow.uturn.left")
                                    }
                                    .tint(.gray)
                                    .saturation(0)
                                }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Einkaufsliste")
        }
        
    }
}



struct ShoppinglistView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppinglistView()
    }
}
