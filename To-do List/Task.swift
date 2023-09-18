//
//  Task.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import Foundation
import UIKit

enum TaskStatus : Codable{
    case Finished
    case Ongoing
}

struct Task : Codable{
    var name: String
    var category : String
    var description : String
    var dueDate : Date
    var creationDate = Date()
    var uuid = UUID()
    var taskStatus : TaskStatus
    
    init(name: String, category: String, description: String, dueDate: Date) {
        self.name = name
        self.category = category
        self.description = description
        self.dueDate = dueDate
        self.taskStatus = .Ongoing
    }
}

struct ToDoListCategory{
    var categoryName : String
    var colour : UIColor
    var uuid = UUID()
    var tasks = [Task]()
    var completedTasks = [Task]()
    var icon = UIImageView()
    
    init(categoryName: String, colour: UIColor,icon : String) {
        self.categoryName = categoryName
        self.colour = colour
        self.icon.image = UIImage(systemName: icon)
    }
    
    mutating func addTask(task: Task){
        self.tasks.append(task)
    }
    
    mutating func completeTask(task: Task){
        guard let index = tasks.firstIndex(where: {$0.uuid == task.uuid})else{
            return
        }
        tasks.remove(at: index)
        completedTasks.append(task)
    }
}
