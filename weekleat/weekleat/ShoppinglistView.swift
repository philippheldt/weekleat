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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var ingredients: FetchedResults<BuyIngr>
    
    var body: some View {
        
        ForEach(ingredients, id:\.self){ ingredient in
            Text(ingredient.title ?? "")
        }
        
        Button{
            let newShoppingItem = BuyIngr(context: moc)
            newShoppingItem.amount = 200
            newShoppingItem.unit = "g"
            newShoppingItem.title = "Mehl"
            newShoppingItem.bought = false
            
        } label:{
            Text("add new Items")
        }
    }
}

struct ShoppinglistView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppinglistView()
    }
}
