//
//  Recipie+CoreDataProperties.swift
//  weekleat
//
//  Created by Philipp Jenny on 27.06.22.
//
//

import Foundation
import CoreData


extension Recipie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipie> {
        return NSFetchRequest<Recipie>(entityName: "Recipie")
    }

    @NSManaged public var colorTheme: Int16
    @NSManaged public var foodType: String?
    @NSManaged public var id: UUID?
    @NSManaged public var portion: Int16
    @NSManaged public var title: String?
    @NSManaged public var tags: String?
    @NSManaged public var ingredients: NSSet?
    
    public var wrappedColorTheme: Int16 {
        colorTheme
    }
    
    public var wrappedFoodType: String {
        foodType ?? "pasta"
    }
    
    public var wrappedPortion: Int16 {
        portion
    }
    
    
    public var wrappedTitle: String {
        title ?? "Unbenanntes Rezept"
    }
    public var wrappedTags: String {
        tags ?? "keine Tags"
    }
    
    public var ingredientsArray: [Ingredient] {
        let set = ingredients as? Set<Ingredient> ?? []
        
        return set.sorted{
            $0.wrappedTitle < $1.wrappedTitle
        }
    }

}

// MARK: Generated accessors for ingredients
extension Recipie {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

extension Recipie : Identifiable {

}
