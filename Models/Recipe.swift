//
//  Recipe.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-14.
//

import Foundation

struct Recipe : Food,Identifiable{
    var id : Int
    let vegetarian : Bool
    let vegan : Bool
    let glutenFree : Bool
    let dairyFree : Bool
    let preparationMinutes : Int
    let cookingMinutes : Int
    let extendedIngredients : [RecipeIngredient]
    let nutrition : Nutrition
}

struct RecipeIngredient : Codable{
    let id : Int
    let image : String
    let consistency : String
    let original : String
    let amount : Double
    let unit : String
    let measures : Measures
}

struct Measures : Codable{
    let us : Measure
    let metric : Measure
}

struct Measure : Codable{
    
    let amount : Double
    let unitShort : String
}
