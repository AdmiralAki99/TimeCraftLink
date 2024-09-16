//
//  CategoryModel.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-09-15.
//

import Foundation
import SwiftData

@Model
class CategoryModel{
    
    var categoryName : String
    var colour : String
    @Relationship(.unique)
    var id : UUID
    @Relationship(deleteRule: .cascade) var tasks : [TaskModel]
    @Relationship(deleteRule: .cascade) var completedTasks : [TaskModel]
    var icon : String
    
    init(categoryName: String, colour: String, tasks: [TaskModel], completedTasks: [TaskModel], icon: String) {
        self.categoryName = categoryName
        self.colour = colour
        self.id = UUID()
        self.tasks = tasks
        self.completedTasks = completedTasks
        self.icon = icon
    }
    
    init(category : ToDoListCategory){
        self.categoryName = category.categoryName
        self.id = category.id
        self.tasks = category.tasks.map({TaskModel(task: $0)})
        self.completedTasks = category.completedTasks.map({TaskModel(task:$0)})
        self.icon = category.icon
        self.colour = category.colour
    }
}
