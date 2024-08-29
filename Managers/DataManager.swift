//
//  DataManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-10-08.
//

import Foundation
import CoreData

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

class DataManager{
    
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
    
    // Using the same CoreData Stack made in AppDelegate just in a manager form to use everywhere
    private let dataModel : NSPersistentContainer
    
    init(){
        encoder.outputFormatting = .prettyPrinted
        self.dataModel = NSPersistentContainer(name: "TimeCraft")
        dataModel.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("FATAL ERROR \(error), \(error.userInfo)")
            }
        })
    }
    
    func writeToFile(with type : FilePath, data: Codable){
        encode(with: data) { result in
            switch result{
            case .success(let data):
                do{
                    try data.write(to: type.filePath)
                }catch{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func encode(with data : Codable , completion: @escaping(Result<Data,Error>)->Void){
        do{
            let encodedString = try encoder.encode(data)
            completion(.success(encodedString))
        }catch{
            completion(.failure(DataManagerAPIError.FailedToEncode))
        }
    }
    
    func decode(type : DataDecodeType, data : Data,completion: @escaping(Result<Codable,Error>) -> Void){
        switch type{
        case .ToDoListManager:
            do{
                let data = try decoder.decode([ToDoListCategory].self, from: data)
                completion(.success(data))
            }catch{
                print(error.localizedDescription)
                completion(.failure(DataManagerAPIError.FailedToDecode))
            }
        }
    }
    
    func readFromFile(type : FilePath,completion: @escaping(Result<Codable,Error>)->Void){
        switch type{
        case .ToDoListManager:
            do{
                let data = try Data(contentsOf: type.filePath)
                decode(type: .ToDoListManager, data: data) { result in
                    switch result{
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(DataManagerAPIError.FailedToReadFromFile))
                    }
                }
            }catch{
                print("Cannot Read From File")
            }
        }
    }
    
    
    func saveDailyNutritionalInfo(dailyProteinIntake: Double, dailyCarbIntake : Double, dailyFatIntake : Double,dailyCaloricalIntake : Double){
        let info = DailyNutritionalInfo(context: self.dataModel.viewContext)
        info.dailyProteinIntake = dailyProteinIntake
        info.dailyFatIntake = dailyFatIntake
        info.dailyCarbIntake = dailyCarbIntake
        info.dailyCaloricalIntake = dailyCaloricalIntake
        info.date = Date()
        
        do{
            try self.dataModel.viewContext.save()
        }catch{
            
        }
    }
    
    func updateDailyNutritonalInfo(dailyProteinIntake: Double,nutritionalEntity: DailyNutritionalInfo){
        nutritionalEntity.dailyProteinIntake = dailyProteinIntake
        
        do{
            try self.dataModel.viewContext.save()
        }catch{
            fatalError(String(describing: ErrorType.FailedToUpdate))
        }
    }
    
    func updateDailyNutritonalInfo(dailyFatIntake: Double,nutritionalEntity: DailyNutritionalInfo){
        nutritionalEntity.dailyFatIntake = dailyFatIntake
        
        do{
            try self.dataModel.viewContext.save()
        }catch{
            fatalError(String(describing: ErrorType.FailedToUpdate))
        }
    }
    
    func updateDailyNutritonalInfo(dailyCarbIntake: Double,nutritionalEntity: DailyNutritionalInfo){
        nutritionalEntity.dailyCarbIntake = dailyCarbIntake
        
        do{
            try self.dataModel.viewContext.save()
        }catch{
            fatalError(String(describing: ErrorType.FailedToUpdate))
        }
    }
    
    func updateDailyNutritonalInfo(dailyCaloricalIntake: Double,nutritionalEntity: DailyNutritionalInfo){
        nutritionalEntity.dailyCaloricalIntake = dailyCaloricalIntake
        
        do{
            try self.dataModel.viewContext.save()
        }catch{
            fatalError(String(describing: ErrorType.FailedToUpdate))
        }
    }
    
    
    func saveMealItem(mealType : String,meal: [any Food]){
        let info = MealEntity(context: self.dataModel.viewContext)
        info.date = Date()
        let grocery = meal.compactMap({$0 as? GroceryItem})
        let recipe = meal.compactMap({$0 as? Recipe})
        info.grocery = grocery.isEmpty ? [] : grocery
        info.recipe = recipe.isEmpty ? [] : recipe
        info.mealType = mealType
        print("DATA MODEL: \(info)")
        do{
            try self.dataModel.viewContext.save()
        }catch{
            fatalError(String(describing: ErrorType.FailedToSave))
        }
        
        
    }
    
    func deleteDailyNutritionalInfo(nutritionalEntity: DailyNutritionalInfo){
        
        self.dataModel.viewContext.delete(nutritionalEntity)
        
        do{
            try self.dataModel.viewContext.save()
        }catch{
            fatalError(String(describing: ErrorType.FailedToUpdate))
        }
    }
    
    func updateMealItem(mealEntity : MealEntity, meal: [any Food]){
        let grocery = meal.compactMap({$0 as? GroceryItem})
        let recipe = meal.compactMap({$0 as? Recipe})
        mealEntity.grocery = grocery
        mealEntity.recipe = recipe
        
        do{
            try self.dataModel.viewContext.save()
        }catch{
            fatalError(String(describing: ErrorType.FailedToUpdate))
        }
    }
    
    func deleteMeal(mealEntity: MealEntity){
        
        self.dataModel.viewContext.delete(mealEntity)
        
        do{
            try self.dataModel.viewContext.save()
        }catch{
            fatalError(String(describing: ErrorType.FailedToUpdate))
        }
    }
    
    func getTodaysMeal(){
        let now = Date()
        let startOfToday = Calendar.current.startOfDay(for: now)
        guard let endOfToday = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday) else{
            return
        }
        
        let fetchReq : NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "%K >= %@ AND %K < %@","date",startOfToday as NSDate, "date",endOfToday as NSDate)
        
        do{
            let res = try self.dataModel.viewContext.fetch(fetchReq)
            
            print(res)
        }catch{
            fatalError(String(describing: ErrorType.FailedToGetTodaysMeals))
        }
        
    }
    
    func getMealsOnDate(date: Date){
        
        let startOfToday = Calendar.current.startOfDay(for: date)
        guard let endOfToday = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday) else{
            return
        }
        
        let fetchReq : NSFetchRequest<MealEntity> = MealEntity.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "%K >= %@ AND %K < %@","date",startOfToday as NSDate, "date",endOfToday as NSDate)
        
        do{
            let res = try self.dataModel.viewContext.fetch(fetchReq)
            
            print(res)
        }catch{
            fatalError(String(describing: ErrorType.FailedToGetMealsOnDate))
        }
    }
    
    
//    func writeToFile(with file : File){
//
//    }
}
