//
//  IngredientSearch.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-15.
//

import Foundation

struct IngredientSearch : Codable{
    var id: Int
    var results : [IngredientSearchResult]
}

struct IngredientSearchResult: Codable,Identifiable{
    var id : Int
    let name : String
    let image : String
}

struct IngredientModel : Food,Identifiable{
    var id : Int
    let name : String
    let image : String
    let aisle : String
    let possibleUnits : [String]
}
