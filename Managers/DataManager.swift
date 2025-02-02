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
    @Published var categoryList : [CategoryModel] = []
    @Published var taskList : [TaskModel] = []
    
    var swiftDataModelContext : ModelContext? = nil
    var swiftDataContainer : ModelContainer? = nil
    
//     Using the same CoreData Stack made in AppDelegate just in a manager form to use everywhere
    
    init(){
        do{
            let containerConfig = ModelConfiguration(isStoredInMemoryOnly: false)
            let modelContainer = try ModelContainer(for: MealModel.self,RecipeModel.self,CategoryModel.self,TaskModel.self, configurations: containerConfig)
            self.swiftDataContainer = modelContainer
            
            DispatchQueue.main.async{
                self.swiftDataModelContext = modelContainer.mainContext
                self.swiftDataModelContext?.autosaveEnabled = true
                self.fetchMeals{ resp in
                    switch resp{
                    case true:
                        break
                    case false:
                        break
                    }
                }
                self.fetchToDoCategory { resp in
                    switch resp{
                    case true:
                        break
                    case false:
                        break
                    }
                }
            }
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to create SwiftData Model Container")
        }
    }
    
    func fetchCategories(completion: @escaping (Bool)->Void){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        
        let fetchReqDescriptor = FetchDescriptor<CategoryModel>(predicate: nil)
        do{
            print(try modelContext.fetch(fetchReqDescriptor))
            completion(true)
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to fetch meals from Context")
            completion(false)
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
    
    func convertToDoListCategory(categories: [CategoryModel]){
        var categoryList = categories.map({ToDoListCategory(category: $0)})
        
        ToDoListManager.toDoList_manager.initializeCategories(categoryList: categoryList)
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
    
    func addToDoListCategory(category : ToDoListCategory){
        
        guard let modelContext = self.swiftDataModelContext else{
            return
        }

        let item = CategoryModel(category: category)
        modelContext.insert(item)
        self.categoryList.append(item)
    }
    
    func addToDoListTask(task : Task){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }

        let item = TaskModel(task: task)
        modelContext.insert(item)
        self.taskList.append(item)
    }
    
    func removeCategory(category: ToDoListCategory){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        guard let model = self.categoryList.filter({$0.id == category.id}).first else{
            return
        }
        
        if let index = self.categoryList.firstIndex(where: {$0.id == category.id}){
            self.categoryList.remove(at: index)
        }
        
        do{
            modelContext.delete(model)
            saveModelContext()
        }
    }
    
    func removeTask(task: Task){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        guard let model = self.taskList.filter({$0.id == task.id}).first else{
            return
        }
        
        if let index = self.taskList.firstIndex(where: {$0.id == task.id}){
            self.taskList.remove(at: index)
        }
        
        do{
            modelContext.delete(model)
            saveModelContext()
        }
    }
    
    private func fetchToDoCategory(completion : @escaping (Bool)->Void){
        guard let modelContext = self.swiftDataModelContext else{
            return
        }
        let fetchReqDescriptor = FetchDescriptor<CategoryModel>(predicate: nil)
        do{
            self.categoryList = try modelContext.fetch(fetchReqDescriptor)
            print("Category Models: \(self.categoryList.map({$0.categoryName}))")
//            self.convertToDoListCategory(categories: self.categoryList)
            completion(true)
        }catch{
            print("Error: \(error.localizedDescription)")
            fatalError("Not able to fetch meals from Context")
            completion(false)
        }
    }
    
    private func convertToDoCategory(category : [CategoryModel]){
        let categoryList = category.map({ToDoListCategory(category: $0)})
        ToDoListManager.toDoList_manager.initializeCategories(categoryList: categoryList)
    }
    
    private func updateToDoListCategory(category : ToDoListCategory){
        
    }
}
