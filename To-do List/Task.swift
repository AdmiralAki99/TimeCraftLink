//
//  Task.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import Foundation
import UIKit
import SwiftData


class Task{
    var name: String
    var category : String
    var summary : String
    var startDate : Date
    var dueDate : Date
    var id = UUID()
    var ongoing : Bool
    
    init(name: String, category: String, summary: String, dueDate: Date,startDate : Date) {
        self.name = name
        self.category = category
        self.summary = summary
        self.dueDate = dueDate
        self.ongoing = true
        self.startDate = startDate
    }
}


class ToDoListCategory{
    
    var categoryName : String
    var colour : String
    var id : UUID
    var tasks : [Task]
    var completedTasks : [Task]
    var icon : String
    
    
    
    init(categoryName: String, colour: String, tasks: [Task], completedTasks: [Task], icon: String) {
        self.categoryName = categoryName
        self.colour = colour
        self.id = UUID()
        self.tasks = tasks
        self.completedTasks = completedTasks
        self.icon = icon
    }
    
    func addTask(task: Task){
        self.tasks.append(task)
    }
    
    func completeTask(task: Task){
        guard let index = tasks.firstIndex(where: {$0.id == task.id})else{
            return
        }
        tasks.remove(at: index)
        completedTasks.append(task)
    }
    
    func getPercentageCompleted()->Double{
        return Double(self.completedTasks.count/self.getTotalTasks())
    }
    
    func getTotalTasks()->Int{
        if self.tasks.count == 0 && self.completedTasks.count == 0{
            return 1
        }
        return (self.tasks.count + self.completedTasks.count)
    }
    
    func setIcon(icon : String){
        self.icon = icon
    }
}

//@Model
//class CategoryColor{
//    var red: CGFloat = 0.0
//    var blue : CGFloat = 0.0
//    var green : CGFloat = 0.0
//    var alpha : CGFloat = 0.0
//    
//    var color : UIColor{
//        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
//    }
//    
//    init(categoryColor: UIColor){
//        categoryColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//    }
//}
