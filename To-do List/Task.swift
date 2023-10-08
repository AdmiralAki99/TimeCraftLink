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

struct ToDoListCategory : Codable{
    
    private enum CodingKeys : String , CodingKey {
        case categoryName
        case colour
        case uuid
        case tasks
        case completedTasks
        case icon
    }
    
    var categoryName : String
    var colour : UIColor
    var uuid = UUID()
    var tasks = [Task]()
    var completedTasks = [Task]()
    var icon = ""
    
    init(categoryName: String, colour: UIColor,icon : String) {
        self.categoryName = categoryName
        self.colour = colour
//        self.icon.image = UIImage(systemName: icon)
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryName = try container.decode(String.self, forKey: .categoryName)
        colour = try container.decode(CategoryColor.self, forKey: .colour).color
        uuid = try container.decode(UUID.self,forKey: .uuid)
        tasks = try container.decode([Task].self,forKey: .tasks)
        completedTasks = try container.decode([Task].self,forKey: .completedTasks)
        icon = try container.decode(String.self, forKey: .icon)
    }
    
    func encode(to encoder: Encoder) throws{
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categoryName, forKey: .categoryName)
        try container.encode(CategoryColor(categoryColor: colour),forKey: .colour)
        try container.encode(uuid,forKey: .uuid)
        try container.encode(tasks, forKey: .tasks)
        try container.encode(completedTasks,forKey: .completedTasks)
        try container.encode(icon,forKey: .icon)
        
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

struct CategoryColor : Codable{
    var red: CGFloat = 0.0
    var blue : CGFloat = 0.0
    var green : CGFloat = 0.0
    var alpha : CGFloat = 0.0
    
    var color : UIColor{
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(categoryColor: UIColor){
        categoryColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
