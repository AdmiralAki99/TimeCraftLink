//
//  DailyNutritionalInfo+CoreDataProperties.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-28.
//
//

import Foundation
import CoreData


extension DailyNutritionalInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyNutritionalInfo> {
        return NSFetchRequest<DailyNutritionalInfo>(entityName: "DailyNutritionalInfo")
    }

    @NSManaged public var dailyCaloricalIntake: Double
    @NSManaged public var dailyCarbIntake: Double
    @NSManaged public var dailyFatIntake: Double
    @NSManaged public var dailyProteinIntake: Double
    @NSManaged public var date: Date?

}

extension DailyNutritionalInfo : Identifiable {

}
