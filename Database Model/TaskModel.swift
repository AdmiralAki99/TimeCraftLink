//
//  TaskModel.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-09-15.
//

import Foundation
import SwiftData

@Model
class TaskModel{
    var name: String
    var category : String
    var summary : String
    var startDate : Date
    var dueDate : Date
    @Relationship(.unique) var id : UUID
    var ongoing : Bool
    
    init(name: String, category: String, summary: String, dueDate: Date,startDate : Date) {
        self.name = name
        self.category = category
        self.summary = summary
        self.dueDate = dueDate
        self.ongoing = true
        self.startDate = startDate
        self.id = UUID()
    }
    
    init(task:Task){
        self.category = task.category
        self.summary = task.summary
        self.name = task.name
        self.startDate = task.startDate
        self.dueDate = task.dueDate
        self.id = task.id
        self.ongoing = task.ongoing
    }
}
