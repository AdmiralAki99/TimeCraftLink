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
    var meal : GroceryModel
    
    init(mealType: String, date: Date, meal: GroceryItem) {
        self.mealType = mealType
        self.date = date
        self.meal = GroceryModel(item: meal)
    }
}
@Model
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
    
    init(item: Nutrient?){
        self.name = item?.name ?? ""
        self.amount = item?.amount ?? 0.0
        self.unit = item?.unit ?? ""
        self.percentOfDailyNeeds = item?.percentOfDailyNeeds ?? 0.0
    }
}
@Model
class CaloricalBreakdownModel{
    let percentProtein : Double
    let percentFat : Double
    let percentCarbs : Double
    
    init(percentProtein: Double, percentFat: Double, percentCarbs: Double) {
        self.percentProtein = percentProtein
        self.percentFat = percentFat
        self.percentCarbs = percentCarbs
    }
    
    init(item: CaloricalBreakdown?){
        self.percentProtein = item?.percentProtein ?? 0.0
        self.percentFat = item?.percentFat ?? 0.0
        self.percentCarbs = item?.percentCarbs ?? 0.0
    }
}
@Model
class NutritionModel{
    let nutrients : [NutrientModel]
    let caloricBreakdown : CaloricalBreakdownModel
    let calories : Double
    let fat : String
    let protein : String
    let carbs : String
    
    init(nutrients: [Nutrient], caloricBreakdown: CaloricalBreakdown, calories: Double, fat: String, protein: String, carbs: String) {
        self.nutrients = nutrients.map({NutrientModel(item: $0)})
        self.caloricBreakdown = CaloricalBreakdownModel(item: caloricBreakdown)
        self.calories = calories
        self.fat = fat
        self.protein = protein
        self.carbs = carbs
    }
    
    init(item:Nutrition?){
        self.nutrients = item?.nutrients.map({NutrientModel(item: $0)}) ?? []
        self.caloricBreakdown = CaloricalBreakdownModel(item: item?.caloricBreakdown ?? nil)
        self.calories = item?.calories ?? 0.0
        self.fat = item?.fat ?? ""
        self.protein = item?.protein ?? ""
        self.carbs = item?.carbs ?? ""
    }
}
@Model
class ServingsModel{
    let number : Double
    let size : Double
    let unit : String
    let raw : String
    
    init(number: Double, size: Double, unit: String, raw: String) {
        self.number = number
        self.size = size
        self.unit = unit
        self.raw = raw
    }
    
    init(item : Servings){
        self.number = item.number ?? 0.0
        self.size = item.size ?? 0.0
        self.unit = item.unit ?? ""
        self.raw = item.raw ?? ""
    }
}
@Model
class GroceryModel{
    var id: Int
    let title: String
    let badges : [String]
    let importantBadges : [String]
    let generatedText : String?
    let nutrition : NutritionModel
    let servings : ServingsModel
//    override var description : String
    let image : String
    let imageType : String
    let images : [String]
    let brand : String
    
    init(id: Int, title: String, badges: [String], importantBadges: [String], generatedText: String, nutrition: Nutrition, servings: Servings, image: String, imageType: String, images: [String], brand: String) {
        self.id = id
        self.title = title
        self.badges = badges
        self.importantBadges = importantBadges
        self.generatedText = generatedText
        self.nutrition = NutritionModel(item: nutrition)
        self.servings = ServingsModel(item: servings)
        self.image = image
        self.imageType = imageType
        self.images = images
        self.brand = brand
    }
    
    init(item: GroceryItem) {
        self.id = item.id
        self.title = item.title ?? ""
        self.badges = item.badges ?? []
        self.importantBadges = item.importantBadges ?? []
        self.generatedText = item.generatedText
        self.nutrition = NutritionModel(item: item.nutrition)
        self.servings = ServingsModel(item: item.servings!)
        self.image = item.image ?? ""
        self.imageType = item.imageType ?? ""
        self.images = item.images ?? []
        self.brand = item.brand ?? ""
    }
}
