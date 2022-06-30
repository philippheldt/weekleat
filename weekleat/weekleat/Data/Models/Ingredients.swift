//
//  Ingredients.swift
//  weekleat
//
//  Created by Philipp Jenny on 22.06.22.
//

import Foundation

struct Ingredients: Identifiable {
    let id: UUID
    var title: String
    var amount: String
    var tag: TagIcon
   
    init(id: UUID = UUID(), title: String, amount: String, tag: TagIcon){
        self.id = id
        self.title = title
        self.amount = amount
        self.tag = tag
    }
}
