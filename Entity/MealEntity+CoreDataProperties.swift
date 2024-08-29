//
//  MealEntity+CoreDataProperties.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-28.
//
//

import Foundation
import CoreData


extension MealEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealEntity> {
        return NSFetchRequest<MealEntity>(entityName: "MealEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged var grocery: [GroceryItem]?
    @NSManaged public var mealType: String?
    @NSManaged var recipe: [Recipe]?

}

extension MealEntity : Identifiable {

}
