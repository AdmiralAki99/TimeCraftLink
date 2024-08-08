//
//  NutritionManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-05.
//

import Foundation

class NutrionManager{
    
    static let nutritionManager = NutrionManager()
    
    struct API{
        static let apiURL = "https://api.nal.usda.gov/fdc/v1"
    }
    
    enum APIResponseError : Error{
        case FailedToGetData
        case AuthenticationError
    }
    
    enum HTTPRequest : String{
        case GET
        case POST
        case PUT
    }
    
    init(){
        
    }
    
    func searchBarcodeID(with barcodeId: String){
        
        
    }
    
    func searchFoodList(with foodName: String){
        
    }
    
}
