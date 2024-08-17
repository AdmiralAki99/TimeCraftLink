//
//  FoodSearchResult.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-15.
//

import Foundation

struct GrocerySearch: Codable{
    let products : [GrocerySearchResult]
}

struct GrocerySearchResult : Codable, Identifiable{
    var id: Int
    let name : String
    let image : String
}
