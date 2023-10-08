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
    }
    
    enum DataDecodeType{
        case ToDoListManager
    }
    
    static let data_manager = DataManager()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(){
        encoder.outputFormatting = .prettyPrinted
    }
    
    func writeToFile(with filePath : URL, data: Codable){
        encode(with: data) { result in
            switch result{
            case .success(let data):
                do{
                    try data.write(to: filePath)
                    
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
    
    func decode(type : DataDecodeType, data : Data){
        switch type{
        case .ToDoListManager:
            do{
                try print(decoder.decode(ToDoListCategory.self, from: data))
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func readFromFile(with filePath : String){
        
    }
    
//    func writeToFile(with file : File){
//
//    }
}
