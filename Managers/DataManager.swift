//
//  DataManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-10-08.
//

import Foundation
import SwiftData

enum FilePath : String{
    case ToDoListManager
    
    var filePath : URL {
        switch self{
        case .ToDoListManager:
            let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let path = filePath.appendingPathComponent("tasks.json")
            return path
        }
    }
    
    var bucket : String{
        switch self{
        case .ToDoListManager:
            return "Todo/tasks.json"
        }
    }
}

class DataManager : ObservableObject{
    
    enum DataManagerAPIError : Error{
        case FailedToEncode
        case FailedToWriteToFile
        case FailedToDecode
        case FailedToReadFromFile
    }
    
    enum DataDecodeType{
        case ToDoListManager
    }
    
    enum ErrorType : Error{
        case FailedToInitialize
        case FailedToSave
        case FailedToUpdate
        case FailedToGetTodaysMeals
        case FailedToGetMealsOnDate
    }
    
    static let data_manager = DataManager()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    @Published var mealList : [MealModel] = []
    @Published var recipeList : [RecipeModel] = []
    
    var swiftDataModelContext : ModelContext? = nil
    var swiftDataContainer : ModelContainer? = nil
    
//     Using the same CoreData Stack made in AppDelegate just in a manager form to use everywhere
    
    init(){
        do{
            let containerConfig = ModelConfiguration(isStoredInMemoryOnly: false)
            let modelContainer = try ModelContainer(for: MealModel.self,RecipeModel.self, configurations: containerConfig)
            self.swiftDataContainer = modelContainer
            
            DispatchQueue.main.async{
                self.swiftDataModelContext = modelContainer.mainContext
                self.swiftDataModelContext?.autosaveEnabled = true
                self.fetchMeals{ resp in
                    switch resp{
                    case true:
                        print("Successfully fetched data")
                        print(self.mealList)
                        break
                    case false:
                        print("Failed To Fetch Data")
                        break
                    }
                }
            }
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to create SwiftData Model Container")
        }
    }
    
    private func fetchMeals(completion : @escaping (Bool)->Void){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        
        var fetchReqDescriptor = FetchDescriptor<MealModel>(predicate: nil)
        var fetchRecipeReqDescriptor = FetchDescriptor<RecipeModel>(predicate: nil)
        do{
            self.mealList = try modelContext.fetch(fetchReqDescriptor)
            self.recipeList = try modelContext.fetch(fetchRecipeReqDescriptor)
            self.convertMealModels(mealModels: mealList,recipeModels: recipeList)
            completion(true)
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to fetch meals from Context")
            completion(false)
        }
    }
    
    
    
    func addMeal(mealType: String, meal : GroceryItem){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }

        let item = MealModel(mealType: mealType, date: Date(), meal: meal)
        modelContext.insert(item)
        self.mealList.append(item)
    }
    
    func addMeal(mealType:String, meal: Recipe){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }

        let item = RecipeModel(mealType: mealType, date: Date(), meal: meal)
        modelContext.insert(item)
        self.recipeList.append(item)
    }
    
    func convertMealModels(mealModels : [MealModel], recipeModels : [RecipeModel]){
        let breakfastMealModels = mealModels.filter({$0.mealType == "Breakfast"})
        let lunchMealModels = mealModels.filter({$0.mealType == "Lunch"})
        let dinnerMealModels = mealModels.filter({$0.mealType == "Dinner"})
        let snacksMealModels = mealModels.filter({$0.mealType == "Snacks"})
        let breakfastRecipeModels = recipeModels.filter({$0.mealType == "Breakfast"})
        let lunchRecipeModels = recipeModels.filter({$0.mealType == "Lunch"})
        let dinnerRecipeModels = recipeModels.filter({$0.mealType == "Dinner"})
        let snackRecipeModels = recipeModels.filter({$0.mealType == "Snack"})
        
        let breakfastMeals = breakfastMealModels.map({convertMealModel(meal: $0)})
        let lunchMeals = lunchMealModels.map({convertMealModel(meal: $0)})
        let dinnerMeals = dinnerMealModels.map({convertMealModel(meal: $0)})
        let snackMeals = snacksMealModels.map({convertMealModel(meal: $0)})
        let breakfastRecipes = breakfastRecipeModels.map({Recipe(recipeModel: $0)})
        let lunchRecipes = lunchRecipeModels.map({Recipe(recipeModel: $0)})
        let dinnerRecipes = dinnerRecipeModels.map({Recipe(recipeModel: $0)})
        let snackRecipes = snackRecipeModels.map({Recipe(recipeModel: $0)})
        
        
        
        NutritionManager.nutritionManager.initializeMeal(mealType: .Breakfast, meals: concatenateMealAndRecipe(meals: breakfastMeals, recipes: breakfastRecipes))
        NutritionManager.nutritionManager.initializeMeal(mealType: .Lunch, meals: concatenateMealAndRecipe(meals: lunchMeals, recipes: lunchRecipes))
        NutritionManager.nutritionManager.initializeMeal(mealType: .Dinner, meals: concatenateMealAndRecipe(meals: dinnerMeals, recipes: dinnerRecipes))
        NutritionManager.nutritionManager.initializeMeal(mealType: .Snack, meals: concatenateMealAndRecipe(meals: snackMeals, recipes: snackRecipes))
        
    }
    
    func concatenateMealAndRecipe(meals:[any Food],recipes: [any Food]) -> [any Food]{
        return meals + recipes
    }
    
    func convertMealModel(meal:MealModel) -> GroceryItem{
        
        let caloricBreakdown = CaloricalBreakdown(percentProtein: meal.meal.nutrition.caloricBreakdown.percentProtein, percentFat: meal.meal.nutrition.caloricBreakdown.percentFat, percentCarbs: meal.meal.nutrition.caloricBreakdown.percentCarbs)
        
        let servings = Servings(number: meal.meal.servings.number, size: meal.meal.servings.size, unit: meal.meal.servings.unit, raw: meal.meal.servings.raw)
        
        let nutrition = Nutrition(nutrients: meal.meal.nutrition.nutrients.map({Nutrient(name: $0.name, amount: $0.amount, unit: $0.unit, percentOfDailyNeeds: $0.percentOfDailyNeeds)}), caloricBreakdown: caloricBreakdown, calories: meal.meal.nutrition.calories, fat: meal.meal.nutrition.fat, protein: meal.meal.nutrition.protein, carbs: meal.meal.nutrition.carbs)
        
        let groceryItem = GroceryItem(id: meal.meal.id, title: meal.meal.title, badges: meal.meal.badges, importantBadges: meal.meal.importantBadges, generatedText: meal.meal.generatedText, nutrition: nutrition, servings: servings, image: meal.meal.image, imageType: meal.meal.imageType, images: meal.meal.images, brand: meal.meal.brand)
        
        return groceryItem
    }
    
    func convertRecipeModel(meal:RecipeModel) -> Recipe{
        let recipe = Recipe(recipeModel: meal)
        return recipe
    }
    
    
    private func saveModelContext(){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        
        do{
            try modelContext.save()
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to save ModelContext")
        }
    }
    
    func removeMeal(meal: GroceryItem){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        guard let model = self.mealList.filter({$0.meal.id == meal.id}).first else{
            return
        }
        
        if let index = self.mealList.firstIndex(where: {$0.meal.id == meal.id}){
            self.mealList.remove(at: index)
        }
        
        do{
            modelContext.delete(model)
            saveModelContext()
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to delete Model")
        }
    }
    
    func removeMeal(meal:Recipe){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        guard let model = self.recipeList.filter({$0.meal.id == meal.id}).first else{
            return
        }
        
        if let index = self.recipeList.firstIndex(where: {$0.meal.id == meal.id}){
            self.recipeList.remove(at: index)
        }
        
        do{
            modelContext.delete(model)
            saveModelContext()
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to delete Model")
        }
    }
        
        
}
