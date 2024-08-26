//
//  Recipe.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-14.
//

import Foundation

struct Recipe : Food,Identifiable{
    var id : Int
    let vegetarian : Bool?
    let vegan : Bool?
    let glutenFree : Bool?
    let dairyFree : Bool?
    let preparationMinutes : Int?
    let cookingMinutes : Int?
    let extendedIngredients : [RecipeIngredient]?
    let nutrition : Nutrition?
    let analyzedInstructions : [RecipeStep]?
    let title : String?
    let readyInMinutes : Int?
    let servings : Int?
    let summary : String?
    let sourceUrl : String?
    let sourceName : String?
    let image : String?
}

struct RecipeIngredient : Codable{
    let id : Int?
    let image : String?
    let name : String?
    let consistency : String?
    let original : String?
    let amount : Double?
    let unit : String?
    let measures : Measures?
}

struct Measures : Codable{
    let us : Measure?
    let metric : Measure?
}

struct Measure : Codable{
    let amount : Double?
    let unitShort : String?
}

struct RecipeNutritionInfo : Codable{
    let calories : String
    let carbs : String
    let fat : String
    let protein : String
    let nutrients : [Nutrient]?
    let bad : [NutritionType]?
    let good : [NutritionType]?
    let caloricBreakdown : CaloricalBreakdown
}

struct NutritionType: Codable{
    let amount: String?
    let indented : Bool?
    let title : String?
    let percentOfDailyNeeds : Double?
}

struct RecipeStep : Codable{
    let number : Int?
    let name : String?
    let steps : [Step]?
}

struct Step : Codable{
    let number : Int
    let step : String?
    let ingredients : [StepIngredient]
}

struct StepIngredient : Codable,Identifiable{
    let id : Int
    let name : String?
    let localizedName : String?
    let image : String?
    
}

