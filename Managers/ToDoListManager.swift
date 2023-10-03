//
//  ToDoListManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import Foundation
import UIKit

class ToDoListManager{
    // Static object to have one manager that stores, displays and manipulates items
    static let toDoList_manager = ToDoListManager()
    // Static collection view so that items can be added and removed from it from any pace without causing discrepancies
    static var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return ToDoListViewController.generateCollectionView(with: sectionIndex)
    })
    // One collection of categories that are stored in the app since there is only one Todo List that needs to be kept
    static var categories = [ToDoListCategory]()
//    static var ongoing_tasks = [Task]()
    // One collection of tasks that are maintained in order to display them in the beginning.
    static var todays_tasks = [Task]()
    
    /*
     MARK: Manager Calls
     */
    
    func createCategory(with categoryName: String, colour: UIColor,icon : String){
        let category = ToDoListCategory(categoryName: categoryName, colour: colour,icon: icon)
        ToDoListManager.categories.append(category)
    }
    
    func createTask(with name: String, category: String, description: String, dueDate: Date){
        let task = Task(name: name, category: category, description: description, dueDate: dueDate)
        
        guard let selectedCategoryIndex = ToDoListManager.categories.firstIndex(where: {return $0.categoryName == category}) else{
            return
        }
        
        addTaskToCategory(with: task, categoryIndex: selectedCategoryIndex)
        
        if Calendar.current.isDateInToday(task.creationDate){
            ToDoListManager.todays_tasks.append(task)
        }
    }
    
    func createTask(with task: Task,category:String){
        guard let selectedCategoryIndex = ToDoListManager.categories.firstIndex(where: {return $0.categoryName == category}) else{
            return
        }
        
        addTaskToCategory(with: task, categoryIndex: selectedCategoryIndex)
        
        if Calendar.current.isDateInToday(task.creationDate){
            ToDoListManager.todays_tasks.append(task)
        }
    }
    
    func addTaskToCategory(with task: Task,categoryIndex : Int){
        var selectedCategory = ToDoListManager.categories[categoryIndex]
        
        selectedCategory.addTask(task: task)
        
        ToDoListManager.categories[categoryIndex] = selectedCategory
    }
    
    func completeTask(with task : Task,category : ToDoListCategory){
        guard let selectedCategoryIndex = ToDoListManager.categories.firstIndex(where: {return $0.uuid == category.uuid}) else{
            return
        }
        
        ToDoListManager.categories[selectedCategoryIndex].completeTask(task: task)
    }
    
    func getTodaysTasks(with date: Date) -> [Task]{
//        for categories in ToDoListManager.categories{
//            for task in categories.tasks{
//                if Calendar.current.isDateInToday(task.creationDate){
//                    ToDoListManager.todays_tasks.append(task)
//                }
//            }
//        }
        return ToDoListManager.todays_tasks
    }
    
    func getCategoryLists() -> [CategoryViewController]{
        let categoryList = ToDoListManager.categories.map({
            return CategoryViewController(category: $0)
        })
        
        return categoryList
    }
    
    func getCategoryTasks(with category : ToDoListCategory) -> [Task]{
        guard let selectedCategoryIndex = ToDoListManager.categories.firstIndex(where: {return $0.categoryName == category.categoryName}) else{
            return []
        }
        
        return ToDoListManager.categories[selectedCategoryIndex].tasks
    }
    
    static func convertTasksToString(){
        var task_string = ""
        for tasks in ToDoListManager.todays_tasks{
            task_string = task_string + tasks.name
        }
        
        BluetoothManager.bluetooth_manager.sendMessage(message: task_string, characteristic: .todoListChar)
    }
}
