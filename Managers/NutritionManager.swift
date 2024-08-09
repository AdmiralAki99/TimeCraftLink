//
//  NutritionManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-05.
//

import Foundation

class NutritionManager : NSObject{
    
    static let nutritionManager = NutrionManager()
    
    struct API{
        static let apiURL = "https://api.nal.usda.gov/fdc/v1"
    }
    
    enum APIResponseError : Error{
        case FailedToGetData
        case AuthenticationError
        case NoFoodHits
    }
    
    enum HTTPResp : String{
        case GET
        case POST
        case PUT
    }
    
    override init(){
        
    }
    
    func searchBarcodeID(with barcodeNumber: String,completion: @escaping (Result<Food,Error>)->Void){
        guard let url = URL(string: "\(API.apiURL)/foods/search?api_key=Fb4ewYXWfglKqzNXndfKc9G16rAyqbi71h0VcSiI&query=\(barcodeNumber)") else{
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data , err == nil else{
                completion(.failure(APIResponseError.FailedToGetData))
                return
            }
            do{
                var data = try JSONDecoder().decode(FoodRequest.self, from: data)
                
                if data.totalHits == 0{
                    completion(.failure(APIResponseError.NoFoodHits))
                }
                
                completion(.success(data.foods[0]))
            }catch{
                print("Barcode Search Info: \(String(describing: err?.localizedDescription))")
                completion(.failure(error))
            }
        }
        
        apiTask.resume()
        
    }
    
    func searchFoodList(with foodName: String){
        
    }
    
}
