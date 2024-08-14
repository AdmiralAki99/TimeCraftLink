//
//  Food.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-07.
//

import Foundation

struct Nutrient : Codable,Identifiable{
    let id = UUID()
    let name : String
    let amount : Double
    let unit : String
    let percentOfDailyNeeds : Double
}

struct CaloricalBreakdown : Codable{
    let percentProtein : Double
    let percentFat : Double
    let percentCarbs : Double
}

struct Nutrition : Codable{
    let nutrients : [Nutrient]
    let caloricBreakdown : CaloricalBreakdown
    let calories : Double
    let fat : String
    let protein : String
    let carbs : String
}

struct Servings : Codable{
    let number : Double
    let size : Double
    let unit : String
    let raw : String
}

struct GroceryItem : Codable{
    let title: String
    let badges : [String]
    let importantBadges : [String]
    let generatedText : String
    let nutrition : Nutrition
    let servings : Servings
    let description : String
    let image : String
    let imageType : String
    let images : [String]
    let brand : String
}


