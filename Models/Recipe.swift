//
//  Recipe.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-14.
//

import Foundation

class Recipe : NSObject,Food,Identifiable{
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
    var nutritionalInfo : RecipeNutritionInfo?
}

class RecipeIngredient : NSObject,Codable{
    let id : Int?
    let image : String?
    let name : String?
    let consistency : String?
    let original : String?
    let amount : Double?
    let unit : String?
    let measures : Measures?
}

class Measures : NSObject,Codable{
    let us : Measure?
    let metric : Measure?
}

class Measure : NSObject,Codable{
    let amount : Double?
    let unitShort : String?
}

class RecipeNutritionInfo : NSObject,Codable{
    let calories : String
    let carbs : String
    let fat : String
    let protein : String
    let nutrients : [Nutrient]?
    let bad : [NutritionType]?
    let good : [NutritionType]?
    let caloricBreakdown : CaloricalBreakdown
}

class NutritionType: NSObject,Codable{
    let amount: String?
    let indented : Bool?
    let title : String?
    let percentOfDailyNeeds : Double?
}

class RecipeStep : NSObject,Codable{
    let number : Int?
    let name : String?
    let steps : [Step]?
}

class Step : NSObject,Codable{
    let number : Int
    let step : String?
    let ingredients : [StepIngredient]
}

class StepIngredient : NSObject,Codable,Identifiable{
    let id : Int
    let name : String?
    let localizedName : String?
    let image : String?
    
}

