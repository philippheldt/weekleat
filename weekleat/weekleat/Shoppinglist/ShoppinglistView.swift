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
                        if !shoppingItem.bought && alreadyExsists(itemame: shoppingItem.title ?? "") == false{
                            ShoppingListItem(titleText: shoppingItem.title ?? "", titleImage: chooseImages(title: (shoppingItem.title ?? "drei")), color: foodTypeToColorTheme(foodType: chooseImages(title: (shoppingItem.title ?? "drei"))), amount: shoppingItem.amount, unit: shoppingItem.unit ?? "", bought: shoppingItem.bought)
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
                }
                Section(header: Text("Schon vorhanden?")){
                    ForEach(shoppingItems, id:\.self) {shoppingItem in
                        if !shoppingItem.bought && alreadyExsists(itemame: shoppingItem.title ?? "") == true{
                            ShoppingListItem(titleText: shoppingItem.title ?? "", titleImage: chooseImages(title: (shoppingItem.title ?? "drei")), color: foodTypeToColorTheme(foodType: chooseImages(title: (shoppingItem.title ?? "drei"))), amount: shoppingItem.amount, unit: shoppingItem.unit ?? "", bought: shoppingItem.bought)
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
                }
                
                Section(header: Text("Gekauft")){
                    ForEach(shoppingItems, id:\.self) {shoppingItem in
                        if shoppingItem.bought{
                            ShoppingListItem(titleText: shoppingItem.title ?? "", titleImage: chooseImages(title: shoppingItem.title ?? ""), color: .YellowLight, amount: shoppingItem.amount, unit: shoppingItem.unit ?? "", bought: shoppingItem.bought)
        
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
