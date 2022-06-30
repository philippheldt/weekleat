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
        VStack{
            ForEach(ingredients, id:\.self){ ingredient in
                Text(ingredient.title ?? "")
            }
            
            Button{
                for ingredient in ingredients {
                    moc.delete(ingredient)
                }
                let newShoppingItem = BuyIngr(context: moc)
                newShoppingItem.amount = 200
                newShoppingItem.unit = "g"
                newShoppingItem.title = "Mehl"
                newShoppingItem.bought = false
                try? moc.save()
            } label:{
                Text("add new Items")
            }
        }
       
    }
}

struct ShoppinglistView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppinglistView()
    }
}
