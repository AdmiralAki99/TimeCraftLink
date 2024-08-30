//
//  CoreDataConversion.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-29.
//

import Foundation
import CoreData

protocol CoreDataObjectConversion{
    associatedtype DataModel
    
    func toManagedObject(in context: NSManagedObjectContext) -> DataModel?
}
