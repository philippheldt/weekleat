//
//  Ingredient+CoreDataProperties.swift
//  weekleat
//
//  Created by Philipp Jenny on 27.06.22.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var title: String?
    @NSManaged public var unit: String?
    @NSManaged public var recipie: Recipie?
    
    public var wrappedAmount: Int16 {
        amount
    }
    
    public var wrappedTitle: String {
        title ?? ""
    }
    
    public var wrappedUnit: String {
        unit ?? ""
    }

}

extension Ingredient : Identifiable {

}
