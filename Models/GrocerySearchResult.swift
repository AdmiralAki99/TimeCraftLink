//
//  FoodSearchResult.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-15.
//

import Foundation

struct GrocerySearch: Codable{
    let products : [GrocerySearchResult]
    let number : Int
}

struct GrocerySearchResult : Codable, Identifiable{
    let id: Int
    let title : String
    let image : String
}
