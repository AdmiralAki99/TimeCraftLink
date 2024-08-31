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
    private var dataModel : ModelContainer = {
        do{
            return try ModelContainer(for: MealModel.self,DailyNutritionalInfo.self,configurations: ModelConfiguration(isStoredInMemoryOnly: true,allowsSave: true))
        }catch{
            fatalError("Failed to create SwiftData Model")
        }
    }()
    
    private var modelContext : ModelContext
    
    init(){
        encoder.outputFormatting = .prettyPrinted
        modelContext = ModelContext(dataModel)
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
    
    func saveGroceryModel(mealType: String,meal: GroceryItem){
        let item = MealModel(mealType: mealType, date: Date(), meal: meal)
        modelContext.insert(item)
        print("Saved Meals Successfully")
        let description = FetchDescriptor<MealModel>()
        do{
            let model = try modelContext.fetch(description)
            print("Number Of Models :\(model.count)")
        }catch{
            
        }
    }
    
    func deleteGroceryModel(mealType: String,id: Int){
        let queryPred = #Predicate<MealModel>{$0.meal.id == id}
        var description = FetchDescriptor<MealModel>(predicate: queryPred)
        do{
            let model = try modelContext.fetch(description)
            for meal in model{
                modelContext.delete(meal)
            }
            print("Deleted Meals Successfully")
        }catch{
            fatalError("No Model Exists with the ID")
        }
        
        
        
    }
}
