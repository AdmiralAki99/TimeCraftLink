//
//  DataManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-10-08.
//

import Foundation
import SwiftData

enum FilePath : String{
    case ToDoListManager
    
    var filePath : URL {
        switch self{
        case .ToDoListManager:
            let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let path = filePath.appendingPathComponent("tasks.json")
            return path
        }
    }
    
    var bucket : String{
        switch self{
        case .ToDoListManager:
            return "Todo/tasks.json"
        }
    }
}

class DataManager : ObservableObject{
    
    enum DataManagerAPIError : Error{
        case FailedToEncode
        case FailedToWriteToFile
        case FailedToDecode
        case FailedToReadFromFile
    }
    
    enum DataDecodeType{
        case ToDoListManager
    }
    
    enum ErrorType : Error{
        case FailedToInitialize
        case FailedToSave
        case FailedToUpdate
        case FailedToGetTodaysMeals
        case FailedToGetMealsOnDate
    }
    
    static let data_manager = DataManager()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    @Published var mealList : [MealModel] = []
    
    var swiftDataModelContext : ModelContext? = nil
    var swiftDataContainer : ModelContainer? = nil
    
//     Using the same CoreData Stack made in AppDelegate just in a manager form to use everywhere
    
    init(){
        do{
            let containerConfig = ModelConfiguration(isStoredInMemoryOnly: false)
            let modelContainer = try ModelContainer(for: MealModel.self, configurations: containerConfig)
            self.swiftDataContainer = modelContainer
            
            DispatchQueue.main.async{
                self.swiftDataModelContext = modelContainer.mainContext
                self.swiftDataModelContext?.autosaveEnabled = true
                self.fetchMeals()
            }
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to create SwiftData Model Container")
        }
    }
    
    private func fetchMeals(){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        
        var fetchReqDescriptor = FetchDescriptor<MealModel>(predicate: nil)
        
        do{
            self.mealList = try modelContext.fetch(fetchReqDescriptor)
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to fetch meals from Context")
        }
    }
    
    func addMeal(mealType: String, meal : GroceryItem){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }

        let item = MealModel(mealType: mealType, date: Date(), meal: meal)
        modelContext.insert(item)
        fetchMeals()
    }
    
    func addMeal(mealType:String, meal: Recipe){
        
    }
    
    
    private func saveModelContext(){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        
        do{
            try modelContext.save()
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to save ModelContext")
        }
    }
        
        
}
