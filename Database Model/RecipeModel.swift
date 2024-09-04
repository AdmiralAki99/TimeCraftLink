//
//  RecipeModel.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-30.
//

import Foundation
import SwiftData

@Model
class RecipeModel{
    var mealType : String
    var date : Date
    var meal : RecipeItemModel
    
    init(mealType: String, date: Date, meal: Recipe) {
        self.mealType = mealType
        self.date = date
        self.meal = RecipeItemModel(recipe: meal)
    }
}
@Model
class RecipeItemModel{
    var id : Int
    let vegetarian : Bool
    let vegan : Bool
    let glutenFree : Bool
    let dairyFree : Bool
    let preparationMinutes : Int
    let cookingMinutes : Int
    let extendedIngredients : [RecipeIngredientModel]
    let nutrition : NutritionModel
    let analyzedInstructions : [RecipeStepModel]
    let title : String
    let readyInMinutes : Int
    let servings : Int
    let summary : String
    let sourceUrl : String
    let sourceName : String
    let image : String?
    var nutritionalInfo : RecipeNutritionInfoModel
    
    init(recipe: Recipe){
        self.id = recipe.id
        self.vegetarian = recipe.vegetarian ?? false
        self.vegan = recipe.vegan ?? false
        self.glutenFree = recipe.glutenFree ?? false
        self.dairyFree = recipe.dairyFree ?? false
        self.preparationMinutes = recipe.preparationMinutes ?? 0
        self.cookingMinutes = recipe.cookingMinutes ?? 0
        self.extendedIngredients = recipe.extendedIngredients?.map({RecipeIngredientModel(recipeIngredient: $0)}) ?? []
        self.nutrition = NutritionModel(item: recipe.nutrition)
        self.analyzedInstructions = recipe.analyzedInstructions?.map({RecipeStepModel(recipeStep: $0)}) ?? []
        self.title = recipe.title ?? ""
        self.readyInMinutes = recipe.readyInMinutes ?? 0
        self.servings = recipe.servings ?? 0
        self.summary = recipe.summary ?? ""
        self.sourceUrl = recipe.sourceUrl ?? ""
        self.sourceName = recipe.sourceName ?? ""
        self.image = recipe.image ?? ""
        self.nutritionalInfo = RecipeNutritionInfoModel(recipeNutritionInfo: recipe.nutritionalInfo)
        
    }
}
@Model
class RecipeNutritionInfoModel{
    let calories : String
    let carbs : String
    let fat : String
    let protein : String
    let nutrients : [NutrientModel]
    var bad : [NutrientTypeModel]
    var good : [NutrientTypeModel]
    var caloricBreakdown : CaloricalBreakdownModel
    
    init(recipeNutritionInfo : RecipeNutritionInfo?){
        self.calories = recipeNutritionInfo?.calories ?? ""
        self.carbs = recipeNutritionInfo?.carbs ?? ""
        self.fat = recipeNutritionInfo?.fat ?? ""
        self.protein = recipeNutritionInfo?.protein ?? ""
        self.nutrients = recipeNutritionInfo?.nutrients?.map({NutrientModel(item: $0)}) ?? []
        self.bad = recipeNutritionInfo?.bad?.map({NutrientTypeModel(nutrientType: $0)}) ?? []
        self.good = recipeNutritionInfo?.good?.map({NutrientTypeModel(nutrientType: $0)}) ?? []
        self.caloricBreakdown = CaloricalBreakdownModel(item: recipeNutritionInfo?.caloricBreakdown)
    }
    
    
}

@Model
class NutrientTypeModel{
    let amount: String
    let indented : Bool
    let title : String
    let percentOfDailyNeeds : Double
    
    init(nutrientType : NutritionType){
        self.amount = nutrientType.amount ?? ""
        self.indented = nutrientType.indented ?? false
        self.title = nutrientType.title ?? ""
        self.percentOfDailyNeeds = nutrientType.percentOfDailyNeeds ?? 0.0
    }
}
@Model
class RecipeStepModel{
    let number : Int
    let name : String
    let steps : [StepModel]
    
    init(recipeStep : RecipeStep){
        self.number = recipeStep.number ?? 0
        self.name = recipeStep.name ?? ""
        self.steps = recipeStep.steps?.map({StepModel(step: $0)}) ?? []
    }
}
@Model
class StepModel{
    let number : Int
    let step : String
    let ingredients : [StepIngredientModel]
    
    init(step: Step){
        self.number = step.number
        self.step = step.step ?? ""
        self.ingredients = step.ingredients.map({StepIngredientModel(stepIngredient: $0)})
    }
}
@Model
class StepIngredientModel{
    let id : Int
    let name : String
    let localizedName : String
    let image : String
    
    init(stepIngredient: StepIngredient){
        self.id = stepIngredient.id
        self.name = stepIngredient.name ?? ""
        self.localizedName = stepIngredient.localizedName ?? ""
        self.image = stepIngredient.image ?? ""
    }
}
@Model
class RecipeIngredientModel{
    let id : Int
    let image : String
    let name : String
    let consistency : String
    let original : String
    let amount : Double
    let unit : String
    let measures : MeasuresModel
    
    init(recipeIngredient: RecipeIngredient){
        self.id = recipeIngredient.id ?? 0
        self.image = recipeIngredient.image ?? ""
        self.name = recipeIngredient.name ?? ""
        self.consistency = recipeIngredient.consistency ?? ""
        self.original = recipeIngredient.original ?? ""
        self.amount = recipeIngredient.amount ?? 0.0
        self.unit = recipeIngredient.unit ?? ""
        self.measures = MeasuresModel(measures: recipeIngredient.measures)
    }
    
}
@Model
class MeasuresModel{
    let us : MeasureModel
    let metric : MeasureModel
    
    init(measures : Measures?){
        self.us = MeasureModel(measure: measures?.us)
        self.metric = MeasureModel(measure: measures?.metric)
    }
}
@Model
class MeasureModel{
    let amount : Double
    let unitShort : String
    
    init(amount: Double, unitShort: String) {
        self.amount = amount
        self.unitShort = unitShort
    }
    
    init(measure: Measure?){
        self.amount = measure?.amount ?? 0.0
        self.unitShort = measure?.unitShort ?? ""
    }
}

