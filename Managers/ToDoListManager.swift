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
    @Published private var todays_tasks : [Task] = []
    @Published private var categoryStatistics : [String:[Int]] = [:]
    /*
     MARK: Manager Calls
     */
    
    init(){
        self.createCategory(with: "Important", colour: "", icon: "hourglass")
        self.createCategory(with: "Personal", colour: "", icon: "person.circle")
        self.createCategory(with: "Projects", colour: "", icon: "wrench.adjustable.fill")
    }
    
    func createCategory(with categoryName: String, colour: String,icon : String){
        let category = ToDoListCategory(categoryName: categoryName, colour: colour,tasks: [],completedTasks: [],icon: icon)
        self.categories.append(category)
        self.initCategoryTasks(category: category)
        
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
        self.updateCategoryStatistics(categoryName: categoryName)
    }
    
    func peekCategory(categoryName: String)-> Task?{
        if let selectIndex = self.categories.firstIndex(where: {$0.categoryName == categoryName}){
            if categories[selectIndex].tasks.count > 0{
                return categories[selectIndex].tasks[0]
            }else{
                return nil
            }
        }
        
        return nil
    }
    
    func getCategoryTaskCount(categoryName: String) -> Int{
        if let selectIndex = self.categories.firstIndex(where: {$0.categoryName == categoryName}){
            return categories[selectIndex].tasks.count
        }
        
        return 0
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
    
    func getCategoryTasks(categoryName : String)->[Task]{
        if let selectIndex = self.categories.firstIndex(where: {$0.categoryName == categoryName}){
            return categories[selectIndex].tasks + categories[selectIndex].completedTasks
        }
        
        return []
    }
    
    func getCategoryStatistics(categoryName : String) -> [Int]{
        return self.categoryStatistics[categoryName] ?? [0,0,0]
    }
    
    func initCategoryTasks(category : ToDoListCategory){
        self.categoryStatistics[category.categoryName] = [0,0,0]
    }
    
    func updateCategoryStatistics(categoryName : String){
        
        if let selectIndex = self.categories.firstIndex(where: {$0.categoryName == categoryName}){
            let todaysTasks = self.categories[selectIndex].tasks.reduce(0) { partialResult, task in
                var sum = partialResult
                if task.startDate.isToday(){
                    sum = partialResult + 1
                }
                return sum
            }
            
            let weeksTasks = self.categories[selectIndex].tasks.reduce(0) { partialResult, task in
                var sum = partialResult
                if task.startDate.isThisWeek(){
                    sum = partialResult + 1
                }
                return sum
            }
            
            let monthlyTasks = self.categories[selectIndex].tasks.reduce(0) { partialResult, task in
                var sum = partialResult
                if task.startDate.isThisMonth(){
                    sum = partialResult + 1
                }
                return sum
            }
            
            // Month Tasks will look like an accumulation but if todays tasks and weeks tasks are subtracted then the remaining ones are not this week or today, they must be in the remaining part of the month
            
            let stats = [todaysTasks >= 0 ? todaysTasks : 0,weeksTasks-todaysTasks >= 0 ? weeksTasks-todaysTasks : 0,monthlyTasks-weeksTasks-todaysTasks >= 0 ? monthlyTasks-weeksTasks-todaysTasks : 0]
            
            self.categoryStatistics[categoryName] = stats
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
