//
//  RecipeSearchResult.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-15.
//

import Foundation

struct RecipeSearch : Codable{
    let number : Int
    let results: [RecipeSearchResult]
}

struct RecipeSearchResult : Codable,Identifiable{
    var id : Int
    let title : String
    let image : String
}
