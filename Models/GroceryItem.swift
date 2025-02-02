//
//  Food.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-07.
//

import Foundation

class Nutrient : Codable,Identifiable{
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
    
    init(nutrient : NutrientModel){
        self.name = nutrient.name
        self.amount = nutrient.amount
        self.unit = nutrient.unit
        self.percentOfDailyNeeds = nutrient.percentOfDailyNeeds
    }
}

class CaloricalBreakdown : Codable{
    let percentProtein : Double
    let percentFat : Double
    let percentCarbs : Double
    
    init(percentProtein: Double, percentFat: Double, percentCarbs: Double) {
        self.percentProtein = percentProtein
        self.percentFat = percentFat
        self.percentCarbs = percentCarbs
    }
    
    init(caloricBreakdown : CaloricalBreakdownModel){
        self.percentProtein = caloricBreakdown.percentProtein
        self.percentFat = caloricBreakdown.percentFat
        self.percentCarbs = caloricBreakdown.percentCarbs
    }
}

class Nutrition : Codable{
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
    
    init(nutrition : NutritionModel){
        self.nutrients = nutrition.nutrients.map({Nutrient(nutrient: $0)})
        self.caloricBreakdown = CaloricalBreakdown(caloricBreakdown: nutrition.caloricBreakdown)
        self.calories = nutrition.calories
        self.fat = nutrition.fat
        self.protein = nutrition.protein
        self.carbs = nutrition.carbs
    }
}

class Servings : Codable{
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

class GroceryItem : Food,Identifiable{
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

protocol Food: Identifiable,Codable{
    var id : Int {get set}
}



//    "id": 9724376,
//    "title": "Délicieuse pancakes",
//    "badges": [
//        "egg_free",
//        "peanut_free",
//        "primal",
//        "sulfite_free",
//        "nut_free",
//        "vegan",
//        "no_preservatives",
//        "soy_free",
//        "msg_free",
//        "no_artificial_colors",
//        "sugar_free",
//        "no_artificial_flavors",
//        "vegetarian",
//        "no_artificial_ingredients",
//        "no_additives",
//        "corn_free",
//        "dairy_free",
//        "paleo",
//        "gluten_free"
//    ],
//    "importantBadges": [
//        "gluten_free"
//    ],
//    "nutrition": {
//        "nutrients": [
//            {
//                "name": "Alcohol",
//                "amount": 0.0,
//                "unit": "g",
//                "percentOfDailyNeeds": 100.0
//            },
//            {
//                "name": "Caffeine",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Calcium",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Carbohydrates",
//                "amount": 37.5,
//                "unit": "g",
//                "percentOfDailyNeeds": 12.5
//            },
//            {
//                "name": "Cholesterol",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Choline",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Copper",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Calories",
//                "amount": 452.0,
//                "unit": "kcal",
//                "percentOfDailyNeeds": 22.6
//            },
//            {
//                "name": "Fat",
//                "amount": 17.5,
//                "unit": "g",
//                "percentOfDailyNeeds": 26.92
//            },
//            {
//                "name": "Saturated Fat",
//                "amount": 5.9,
//                "unit": "g",
//                "percentOfDailyNeeds": 36.88
//            },
//            {
//                "name": "Trans Fat",
//                "amount": 0.0,
//                "unit": "g",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Fiber",
//                "amount": 0.0,
//                "unit": "g",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Fluoride",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Folate",
//                "amount": 0.0,
//                "unit": "µg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Folic Acid",
//                "amount": 0.0,
//                "unit": "µg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Iodine",
//                "amount": 0.0,
//                "unit": "µg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Iron",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Magnesium",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Manganese",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Vitamin B3",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Vitamin B5",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Phosphorus",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Potassium",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Protein",
//                "amount": 36.0,
//                "unit": "g",
//                "percentOfDailyNeeds": 72.0
//            },
//            {
//                "name": "Vitamin B2",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Selenium",
//                "amount": 0.0,
//                "unit": "µg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Sodium",
//                "amount": 0.3,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.01
//            },
//            {
//                "name": "Sugar",
//                "amount": 1.8,
//                "unit": "g",
//                "percentOfDailyNeeds": 2.0
//            },
//            {
//                "name": "Sugar Alcohol",
//                "amount": 0.0,
//                "unit": "g",
//                "percentOfDailyNeeds": 100.0
//            },
//            {
//                "name": "Vitamin B1",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Vitamin A",
//                "amount": 0.0,
//                "unit": "IU",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Vitamin B12",
//                "amount": 0.0,
//                "unit": "µg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Vitamin B6",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Vitamin C",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Vitamin D",
//                "amount": 0.0,
//                "unit": "µg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Vitamin E",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Vitamin K",
//                "amount": 0.0,
//                "unit": "µg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Zinc",
//                "amount": 0.0,
//                "unit": "mg",
//                "percentOfDailyNeeds": 0.0
//            },
//            {
//                "name": "Net Carbohydrates",
//                "amount": 37.5,
//                "unit": "g",
//                "percentOfDailyNeeds": 13.64
//            }
//        ],
//        "caloricBreakdown": {
//            "percentProtein": 31.89,
//            "percentFat": 34.88,
//            "percentCarbs": 33.23
//        },
//        "calories": 452.0,
//        "fat": "17.5g",
//        "protein": "36g",
//        "carbs": "37.5g"
//    },
//    "servings": {
//        "number": 1.0,
//        "size": null,
//        "unit": null,
//        "raw": null
//    },
//    "spoonacularScore": 100.0,
//    "aisle": null,
//    "description": null,
//    "image": "https://img.spoonacular.com/products/9724376-312x231.jpg",
//    "imageType": "jpg",
//    "images": [
//        "https://img.spoonacular.com/products/9724376-90x90.jpg",
//        "https://img.spoonacular.com/products/9724376-312x231.jpg",
//        "https://img.spoonacular.com/products/9724376-636x393.jpg"
//    ],
//    "generatedText": "Thinking about having some pancake today? Délicieuse pancakes is one option; let's take a closer look. This product has no ingredients (in our experience: the fewer ingredients, the better!)",
//    "upc": "8719214562236",
//    "brand": null,
//    "ingredients": [],
//    "ingredientCount": 0,
//    "ingredientList": "",
//    "credits": {
//        "text": "openfoodfacts.org under (ODbL) v1.0",
//        "link": "https://opendatacommons.org/licenses/odbl/1-0/",
//        "image": "openfoodfacts.org under CC BY-SA 3.0 DEED",
//        "imageLink": "https://creativecommons.org/licenses/by-sa/3.0/deed.en"
//    }
