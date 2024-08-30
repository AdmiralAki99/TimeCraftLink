//
//  MealEntity+CoreDataClass.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-28.
//
//

import Foundation
import CoreData

@objc(MealEntity)
public class MealEntity: NSManagedObject,Decodable{
    
    enum CodingKeys: CodingKey {
        case date
        case grocery
        case recipe
        case mealType
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.date, forKey: CodingKeys.date)
        try container.encode(self.grocery, forKey: .grocery)
        try container.encode(self.mealType,forKey: .mealType)
        try container.encode(self.recipe, forKey: .recipe)
    }
    
    public required convenience init(from decoder : Decoder) throws{
        guard let context = decoder.userInfo[CodingUserInfoKey(rawValue: "MealEntityContext")!] as? NSManagedObjectContext else{
            fatalError("Error in Decoding Data")
            return
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.grocery = try container.decode(GroceryItem.self,forKey: .grocery)
        self.recipe = try container.decode(Recipe.self,forKey: .recipe)
        self.mealType = try container.decode(String.self, forKey: .mealType)
    }
    
}
