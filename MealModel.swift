//
//  GroceryModel.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-30.
//

import Foundation
import SwiftData
@Model
class MealModel{
    var mealType : String
    var date : Date
    var meal : GroceryItem
    
    init(mealType: String, date: Date, meal: GroceryItem) {
        self.mealType = mealType
        self.date = date
        self.meal = meal
    }
}

class NutrientModel {
    let id = UUID()
    let name : String
    let amount : Double
    let unit : String
    let percentOfDailyNeeds : Double
    
    init(name: String, amount: Double, unit: String, percentOfDailyNeeds: Double) {
        self.name = name
        self.amount = amount
        self.unit = unit
        self.percentOfDailyNeeds = percentOfDailyNeeds
    }
}

class CaloricalBreakdownModel{
    let percentProtein : Double
    let percentFat : Double
    let percentCarbs : Double
    
    init(percentProtein: Double, percentFat: Double, percentCarbs: Double) {
        self.percentProtein = percentProtein
        self.percentFat = percentFat
        self.percentCarbs = percentCarbs
    }
}

class NutritionModel{
    let nutrients : [Nutrient]
    let caloricBreakdown : CaloricalBreakdown
    let calories : Double
    let fat : String
    let protein : String
    let carbs : String
    
    init(nutrients: [Nutrient], caloricBreakdown: CaloricalBreakdown, calories: Double, fat: String, protein: String, carbs: String) {
        self.nutrients = nutrients
        self.caloricBreakdown = caloricBreakdown
        self.calories = calories
        self.fat = fat
        self.protein = protein
        self.carbs = carbs
    }
}

class ServingsModel{
    let number : Double?
    let size : Double?
    let unit : String?
    let raw : String?
    
    init(number: Double?, size: Double?, unit: String?, raw: String?) {
        self.number = number
        self.size = size
        self.unit = unit
        self.raw = raw
    }
}

class GroceryItem{
    var id: Int
    let title: String?
    let badges : [String]?
    let importantBadges : [String]?
    let generatedText : String?
    let nutrition : Nutrition?
    let servings : Servings?
//    override var description : String
    let image : String?
    let imageType : String?
    let images : [String]?
    let brand : String?
    
    init(id: Int, title: String?, badges: [String]?, importantBadges: [String]?, generatedText: String?, nutrition: Nutrition?, servings: Servings?, image: String?, imageType: String?, images: [String]?, brand: String?) {
        self.id = id
        self.title = title
        self.badges = badges
        self.importantBadges = importantBadges
        self.generatedText = generatedText
        self.nutrition = nutrition
        self.servings = servings
        self.image = image
        self.imageType = imageType
        self.images = images
        self.brand = brand
    }
}
