//
//  DataManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-10-08.
//

import Foundation

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
    }
    
    static let data_manager = DataManager()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(){
        encoder.outputFormatting = .prettyPrinted
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
    
//    func writeToFile(with file : File){
//
//    }
}
