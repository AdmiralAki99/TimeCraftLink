//
//  ToDoListManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import Foundation
import UIKit

class ToDoListManager : ObservableObject{
    // Static object to have one manager that stores, displays and manipulates items
    static let toDoList_manager = ToDoListManager()

    
    @Published private var categories : [ToDoListCategory] = []
//    static var ongoing_tasks = [Task]()
    // One collection of tasks that are maintained in order to display them in the beginning.
    @Published private var todays_tasks : [Task] = []
    
    /*
     MARK: Manager Calls
     */
    
    init(){
        self.categories.append(ToDoListCategory(categoryName: "Important", colour: "", icon: ""))
        self.categories.append(ToDoListCategory(categoryName: "Personal", colour: "", icon: ""))
        self.categories.append(ToDoListCategory(categoryName: "Projects", colour: "", icon: ""))
    }
    
    func createCategory(with categoryName: String, colour: String,icon : String){
        let category = ToDoListCategory(categoryName: categoryName, colour: colour,icon: icon)
        self.categories.append(category)
    }
    
    func createTask(with name: String, category: String, description: String, dueDate: Date,startDate : Date){
        let task = Task(name: name, category: category, summary: description, dueDate: dueDate, startDate: startDate)
        
        addTaskToCategory(with: task, categoryName: category)
        
        if Calendar.current.isDateInToday(task.creationDate){
            self.todays_tasks.append(task)
        }
    }
    
    func createTask(with task: Task,category:String){
        addTaskToCategory(with: task, categoryName: category)
        
        if Calendar.current.isDateInToday(task.creationDate){
            self.todays_tasks.append(task)
        }
    }
    
    func addTaskToCategory(with task: Task,categoryName: String){
        guard let selectedCategoryIndex = self.categories.enumerated().filter({ index,element in
            return element.categoryName == categoryName
        }).map({ index,_ in
            return index
        }).first else{
            return
        }
        
        self.categories[selectedCategoryIndex].tasks.append(task)
    }
    
    func completeTask(with task : Task,categoryName : String){
        guard let selectedCategoryIndex = self.categories.enumerated().filter({ index,element in
            return element.categoryName == categoryName
        }).map({ index,_ in
            return index
        }).first else{
            return
        }
        
        self.categories[selectedCategoryIndex].completeTask(task: task)
    }
    
    func getTodaysTasks(with date: Date) -> [Task]{
//        for categories in ToDoListManager.categories{
//            for task in categories.tasks{
//                if Calendar.current.isDateInToday(task.creationDate){
//                    ToDoListManager.todays_tasks.append(task)
//                }
//            }
//        }
        return self.todays_tasks
    }
    
    func convertTasksToString(){
        var task_string = ""
        for tasks in self.todays_tasks{
            task_string = task_string + tasks.name + ";"
        }
        
        BluetoothManager.bluetooth_manager.sendMessage(message: task_string, characteristic: .todoListChar)
    }
    
    func convertTaskStatusToString(){
        var task_status = ""
        for tasks in todays_tasks{
            switch tasks.ongoing{
            case true:
                task_status = task_status + "T"
            case false:
                task_status = task_status + "F"
            }
        }
        
    }
    
    func changeTodaysTaskCompletionStatus(index: Int){
        self.todays_tasks[index].ongoing.toggle()
    }
    
    func getTodaysTasks() -> [Task]{
        return self.todays_tasks
    }
    
    func getCategories() -> [ToDoListCategory]{
        return self.categories
    }
    
    func storeTasks(){
//        DataManager.data_manager.writeToFile(with: .ToDoListManager, data: ToDoListManager.categories)
    }
    
    func readTasksFromLocalFile(){
//        DataManager.data_manager.readFromFile(type: .ToDoListManager) { result in
//            switch result{
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                break
//            }
//        }
    }
    
    func uploadTasksToFile(){
        FirebaseManager.firebase_manager.uploadFile(filePath: FilePath.ToDoListManager.filePath,bucket:FilePath.ToDoListManager.bucket) { result in
            switch result{
            case .success:
                print("Upload Success")
            case .failure(let error):
                break
            }
        }
    }
}
