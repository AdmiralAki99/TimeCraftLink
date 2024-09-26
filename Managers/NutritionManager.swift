//
//  NutritionManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-05.
//

import Foundation

enum MealType : String{
    case Breakfast
    case Lunch
    case Dinner
    case Snack
}

enum MacroType : String{
    case Protein
    case Carbs
    case Fat
}

class NutritionManager : NSObject,ObservableObject{
    
    static var nutritionManager = NutritionManager()
    
    private let dailyFoodItems : [GroceryItem] = []
    // TODO: FIX THE BLOODY TYPOS
    @Published private var dailyProteinIntake : Double = 0.0
    @Published private var dailyCarbIntake : Double = 0.0
    @Published private var dailyFatIntake : Double = 0.0
    @Published private var dailyCaloricalIntake : Double = 0.0
    
    @Published private var breakfastMeals : [any Food] = []
    @Published private var lunchMeals : [any Food] = []
    @Published private var dinnerMeals : [any Food] = []
    @Published private var snacks : [any Food] = []
    
    @Published private var breakfastRecipeNutritionInfo : [RecipeNutritionInfo] = []
    @Published private var lunchRecipeNutritionInfo : [RecipeNutritionInfo] = []
    @Published private var dinnerRecipeNutritionInfo : [RecipeNutritionInfo] = []
    @Published private var snacksRecipeNutritionInfo : [RecipeNutritionInfo] = []
    
    private var proteinDailyIntakeLimit : Double = 178.0
    private var fatDailyIntakeLimit : Double = 58.74
    private var carbsDailyIntakeLimit : Double = 100.0
    private var caloricalDailyLimit : Double = 1500.0
    
    private let encoder : JSONEncoder = JSONEncoder()
    
    private var apiKey : String
    
    
    struct API{
        static let UPC_URL = "https://api.spoonacular.com/food/products/upc"
        static let RECIPE_URL = ""
    }
    
    enum APIResponseError : Error{
        case FailedToGetData
        case AuthenticationError
        case NoFoodHits
        case FailedToDecodeData
    }
    
    enum HTTPResp : String{
        case GET
        case POST
        case PUT
    }
    
    override init(){
        if let key = Bundle.main.infoDictionary?["API_KEY"] as? String{
            self.apiKey = key
        }else{
            self.apiKey = ""
        }
    }
    
    func searchBarcodeID(with barcodeNumber: String,completion: @escaping (Result<GroceryItem,Error>)->Void){
        guard let url = URL(string: "\(API.UPC_URL)/\(barcodeNumber)?apiKey=\(self.apiKey)") else{
            return
        }
        let apiTask = URLSession.shared.dataTask(with: url){data,resp,err in
            guard let data = data ,err == nil else{
                completion(.failure(APIResponseError.FailedToGetData))
                return
            }
            // Data is received, now it needs to be decoded
            do{
                let data = try JSONDecoder().decode(GroceryItem.self, from: data)
                
                completion(.success(data))
            }catch{
                print("Barcode Search Info: \(String(describing: err?.localizedDescription))")
            }
        }
        
        apiTask.resume()
        
    }
    
    func searchRecipeID(with recipeName: String, offset: Int, completion: @escaping (Result<RecipeSearch,Error>)->Void){
        // TODO: Implement This
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(self.apiKey)&query=\(recipeName)&number=50") else{
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data, err == nil else{
                return completion(.failure(APIResponseError.FailedToGetData))
            }
            
            do{
                let data = try JSONDecoder().decode(RecipeSearch.self, from: data)
                
                completion(.success(data))
            }
            catch{
                print("Complex Search Error: \(String(describing: err))")
            }
        }
        
        apiTask.resume()
    }
    
    func searchRecipeFromID(with recipeID : Int, completion: @escaping (Result<Recipe,Error>)->Void){
        // TODO: Implement This
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(recipeID)/information?apiKey=\(self.apiKey)")else{
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data, err == nil else{
                return completion(.failure(APIResponseError.FailedToGetData))
            }
            
            do{
                var data = try JSONDecoder().decode(Recipe.self, from: data)
                DispatchQueue.main.async {
                    self.getRecipeNutritionalInfo(with: "\(recipeID)") { res in
                        switch res{
                        case .success(let info):
                            data.nutritionalInfo = info
                            break
                        case .failure(let error ):
                            print(error)
                        }
                        print("NutritionalInfo: \(data.nutritionalInfo)")
                        completion(.success(data))
                    }
                }
            }catch{
                print("Error: \(String(describing: err))")
                completion(.failure(APIResponseError.FailedToDecodeData))
            }
        }
        
        apiTask.resume()
    }
    
    func getRecipeNutritionalInfo(with recipeId : String,completion: @escaping (Result<RecipeNutritionInfo,Error>)->Void){
        guard let url = URL(string:"https://api.spoonacular.com/recipes/\(recipeId)/nutritionWidget.json?apiKey=\(self.apiKey)") else{
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data , err == nil else{
                completion(.failure(APIResponseError.FailedToGetData))
                return
            }
            
            do{
                let data = try JSONDecoder().decode(RecipeNutritionInfo.self, from: data)
                completion(.success(data))
            }catch{
                print("RECIPE NUTR. ERROR")
                completion(.failure(APIResponseError.FailedToDecodeData))
            }
        }
        
        apiTask.resume()
    }
    
    func searchGroceryID(with searchQuery : String, offset: Int, completion : @escaping (Result<GrocerySearch,Error>)->Void){
        
        guard let url = URL(string: "https://api.spoonacular.com/food/products/search?apiKey=\(self.apiKey)&query=\(searchQuery)&number=50&offset=\(offset)") else{
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data, err == nil else{
                return completion(.failure(APIResponseError.FailedToGetData))
            }
            
            do{
                let data = try JSONDecoder().decode(GrocerySearch.self, from: data)
                
                completion(.success(data))
            }
            catch{
                print("Complex Search Error: \(String(describing: err))")
            }
        }
        
        apiTask.resume()
    }
    
    func searchGroceryFromID(with id: String,completion: @escaping (Result<GroceryItem,Error>)->Void){
        guard let url = URL(string: "https://api.spoonacular.com/food/products/\(id)?apiKey=\(self.apiKey)") else{
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data, err == nil else{
                completion(.failure(APIResponseError.FailedToGetData))
                return
            }
            do{
                let data = try JSONDecoder().decode(GroceryItem.self, from: data)
                
                completion(.success(data))
            }catch{
                completion(.failure(APIResponseError.FailedToDecodeData))
            }
        }
        
        apiTask.resume()
    }
    
    func searchPureIngredientID(with query : String, offset: Int, completion: @escaping (Result<IngredientSearch,Error>)->Void){
        guard let url = URL(string: "https://api.spoonacular.com/food/ingredients/search?apiKey=\(self.apiKey)&query=\(query)&number=50&offset=\(offset)") else{
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data, err == nil else{
                completion(.failure(APIResponseError.FailedToGetData))
                return
            }
            
            do{
                let data = try JSONDecoder().decode(IngredientSearch.self, from: data)
                
                completion(.success(data))
            }catch{
                completion(.failure(APIResponseError.FailedToDecodeData))
            }
        }
        
        apiTask.resume()
    }
    
    func searchPureIngredientFromID(with id: String, completion: @escaping (Result<IngredientModel,Error>)->Void){
        guard let url = URL(string: "https://api.spoonacular.com/food/ingredients/\(id)/information?apiKey=\(self.apiKey)") else{
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { data, url, err in
            guard let data = data, err == nil else{
                completion(.failure(APIResponseError.FailedToGetData))
                return
            }
            
            do{
                let data = try JSONDecoder().decode(IngredientModel.self, from: data)
                
                completion(.success(data))
            }catch{
                completion(.failure(APIResponseError.FailedToDecodeData))
            }
        }
        
        apiTask.resume()
    }
    
    
    
    func searchFoodList(with foodName: String){
        
    }
    
    func setProteinDailyIntake(newLimit : Double){
        self.proteinDailyIntakeLimit = newLimit
    }
    
    func setCarbsDailyIntake(newLimit : Double){
        self.carbsDailyIntakeLimit = newLimit
    }
    
    func setFatDailyIntake(newLimit : Double){
        self.fatDailyIntakeLimit = newLimit
    }
    
    func getDailyProteinTarget()->Double{
        return self.proteinDailyIntakeLimit
    }
    
    func getDailyFatTarget()->Double{
        return self.fatDailyIntakeLimit
    }
    
    func getDailyCarbTarget()->Double{
        return self.carbsDailyIntakeLimit
    }
    
    func getCaloricalDailyTarget() -> Double{
        return self.caloricalDailyLimit
    }
    
    func addProteinMacro(intake: Double){
        self.dailyProteinIntake = self.dailyProteinIntake + intake
    }
    
    func removeProteinMacro(intake : Double){
        self.dailyProteinIntake = self.dailyProteinIntake - intake
    }
    
    func addCarbMacro(intake: Double){
        self.dailyCarbIntake = self.dailyCarbIntake + intake
    }
    
    func removeCarbMacro(intake: Double){
        self.dailyCarbIntake = self.dailyCarbIntake - intake
    }
    
    func addFatMacro(intake: Double){
        self.dailyFatIntake = self.dailyFatIntake + intake
    }
    
    func removeFatMacro(intake: Double){
        self.dailyFatIntake = self.dailyFatIntake - intake
    }
    
    func addCalories(intake: Double){
        self.dailyCaloricalIntake = self.dailyCaloricalIntake + intake
    }
    
    func removeCalories(intake: Double){
        self.dailyCaloricalIntake = self.dailyCaloricalIntake - intake
    }
    
    func getDailyCaloricalIntake() -> Double{
        return self.dailyCaloricalIntake
    }
    
    func getDailyProteinIntake() -> Double{
        return self.dailyProteinIntake
    }
    
    func getDailyCarbIntake() -> Double{
        return self.dailyCarbIntake
    }
    
    func getDailyFatIntake()-> Double{
        return self.dailyFatIntake
    }
    
    func getMeals(mealType : MealType) -> [any Food]{
        switch mealType{
        case .Breakfast:
            return self.breakfastMeals
        case .Lunch:
            return self.lunchMeals
        case .Dinner:
            return self.dinnerMeals
        case .Snack:
            return self.snacks
        }
    }
    
    func addMacros(meal: any Food){
            if let meal = meal as? GroceryItem{
                guard let proteinNutrient = meal.nutrition?.nutrients.filter({$0.name == "Protein"}).first else{
                    return
                }
                guard let carbNutrient = meal.nutrition?.nutrients.filter({$0.name == "Carbohydrates"}).first else{
                    return
                }
                guard let fatNutrient = meal.nutrition?.nutrients.filter({$0.name == "Fat"}).first else{
                    return
                }
                
                let calorie = meal.nutrition?.calories
                
                self.addProteinMacro(intake: proteinNutrient.amount)
                self.addCarbMacro(intake: carbNutrient.amount)
                self.addFatMacro(intake: fatNutrient.amount)
                self.addCalories(intake: calorie ?? 0.0)
                
                
            }else if let meal = meal as? Recipe{
                guard let proteinNutrient = meal.nutritionalInfo?.nutrients?.filter({$0.name == "Protein"}).first else{
                    return
                }
                guard let carbNutrient = meal.nutritionalInfo?.nutrients?.filter({$0.name == "Carbohydrates"}).first else{
                    return
                }
                guard let fatNutrient = meal.nutritionalInfo?.nutrients?.filter({$0.name == "Fat"}).first else{
                    return
                }
                
                let calorie = Double(meal.nutritionalInfo?.calories ?? "")
                
                
                self.addProteinMacro(intake: proteinNutrient.amount)
                self.addCarbMacro(intake: carbNutrient.amount)
                self.addFatMacro(intake: fatNutrient.amount)
                self.addCalories(intake: calorie ?? 0.0)
            }
        }
    
    func removeMacros(meal: GroceryItem){
        guard let proteinNutrient = meal.nutrition?.nutrients.filter({$0.name == "Protein"}).first else{
            return
        }
        guard let carbNutrient = meal.nutrition?.nutrients.filter({$0.name == "Carbohydrates"}).first else{
            return
        }
        guard let fatNutrient = meal.nutrition?.nutrients.filter({$0.name == "Fat"}).first else{
            return
        }
        
        let calorie = meal.nutrition?.calories
        
        self.removeProteinMacro(intake: proteinNutrient.amount)
        self.removeCarbMacro(intake: carbNutrient.amount)
        self.removeFatMacro(intake: fatNutrient.amount)
        self.removeCalories(intake: calorie ?? 0.0)
    }
    
    func removeMacros(meal:Recipe){
        guard let proteinNutrient = meal.nutritionalInfo?.nutrients?.filter({$0.name == "Protein"}).first else{
            return
        }
        guard let carbNutrient = meal.nutritionalInfo?.nutrients?.filter({$0.name == "Carbohydrates"}).first else{
            return
        }
        guard let fatNutrient = meal.nutritionalInfo?.nutrients?.filter({$0.name == "Fat"}).first else{
            return
        }
        
        let calorie = Double(meal.nutritionalInfo?.calories ?? "")
        
        print("Recipe Protein : \(proteinNutrient.amount), Recipe Carbs : \(carbNutrient.amount), Recipe Fat : \(fatNutrient.amount), Recipe Calories : \(calorie)")
        
        self.removeProteinMacro(intake: proteinNutrient.amount)
        self.removeCarbMacro(intake: carbNutrient.amount)
        self.removeFatMacro(intake: fatNutrient.amount)
        self.removeCalories(intake: calorie ?? 0.0)
    }
    
    func addMealToList(mealType: MealType,meal:any Food){
        switch mealType{
        case .Breakfast:
            self.breakfastMeals.append(meal)
            self.addMacros(meal: meal)
            //            DataManager.data_manager.saveGroceryModel(mealType: "Breakfast", meal: meal as! GroceryItem)
            break
        case .Lunch:
            self.lunchMeals.append(meal)
            self.addMacros(meal: meal)
            break
        case .Dinner:
            self.dinnerMeals.append(meal)
            self.addMacros(meal: meal)
            break
        case .Snack:
            self.snacks.append(meal)
            self.addMacros(meal: meal)
            break
        }
    }
    
    func getMealMacros(mealType : MealType,macroType : MacroType,completion: @escaping (Double)->Void){
            switch mealType{
            case .Breakfast:
                switch macroType{
                case .Protein:
                    let totalSum = self.breakfastMeals.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Protein"}).first)?.amount ?? 0.0)
                        }else if let meal = item as? Recipe{
                            sum = partialResult + ((meal.nutritionalInfo?.nutrients?.filter({$0.name == "Protein"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    
                    completion(totalSum)
                case .Carbs:
                    let totalSum = self.breakfastMeals.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Carbohydrates"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Carbohydrates"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    
                    completion(totalSum)
                case .Fat:
                    let totalSum = self.breakfastMeals.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Fat"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Fat"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    
                    completion(totalSum)
                }
            case .Lunch:
                switch macroType{
                case .Protein:
                    let totalSum = self.lunchMeals.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Protein"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Protein"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    completion(totalSum)
                case .Carbs:
                    let totalSum = self.lunchMeals.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Carbohydrates"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Carbohydrates"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    
                    completion(totalSum)
                case .Fat:
                    let totalSum = self.lunchMeals.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Fat"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Fat"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    
                    completion(totalSum)
                }
            case .Dinner:
                switch macroType{
                case .Protein:
                    let totalSum = self.dinnerMeals.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Protein"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Protein"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    completion(totalSum)
                case .Carbs:
                    let totalSum = self.dinnerMeals.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Carbohydrates"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Carbohydrates"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    completion(totalSum)
                case .Fat:
                    let totalSum = self.dinnerMeals.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Fat"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Fat"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    
                    completion(totalSum)
                }
            case .Snack:
                switch macroType{
                case .Protein:
                    let totalSum = self.snacks.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Protein"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Protein"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    
                    completion(totalSum)
                case .Carbs:
                    let totalSum = self.snacks.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Carbohydrates"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Carbohydrates"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    completion(totalSum)
                case .Fat:
                    let totalSum = self.snacks.reduce(0) { (partialResult, item) in
                        var sum = partialResult
                        if let item = item as? GroceryItem{
                            sum = partialResult + ((item.nutrition?.nutrients.filter({$0.name == "Fat"}).first)?.amount ?? 0.0)
                        }else if let item = item as? Recipe{
                            sum = partialResult + ((item.nutritionalInfo?.nutrients?.filter({$0.name == "Fat"}).first)?.amount ?? 0.0)
                        }
                        return sum
                    }
                    completion(totalSum)
                }
            }
        }
    
    func getRemainingCalories() -> Double{
        return self.caloricalDailyLimit - self.dailyCaloricalIntake
    }
   
    func getRemainingProtein() -> Double{
        return self.proteinDailyIntakeLimit - self.dailyProteinIntake
    }

    func getRemainingCarb() -> Double{
        return self.carbsDailyIntakeLimit - self.dailyCarbIntake
    }

    func getRemainingFat() -> Double{
        return self.fatDailyIntakeLimit - self.dailyFatIntake
    }

    func encodeMeal(foodItem : any Food,completion: @escaping(String)->Void){
        if let item = foodItem as? GroceryItem{
            do{
                let encodedData = try encoder.encode(item)
                guard let data = String(data: encodedData, encoding: .utf8) else{
                    fatalError("String Failed To Create")
                }
                completion(data)
            }catch{
                fatalError("Could Not Encode GroceryItem")
            }
        }else if let item = foodItem as? Recipe{
            do{
                let encodedData = try encoder.encode(item)
                guard let data = String(data: encodedData, encoding: .utf8) else{
                    fatalError("String Failed To Create")
                }
                completion(data)
            }catch{
                fatalError("Could Not Encode GroceryItem")
            }
        }
    }

    func initializeMeal(mealType : MealType,meals:[any Food]){
        switch mealType{
        case .Breakfast:
            self.breakfastMeals = meals
            break
        case .Lunch:
            self.lunchMeals = meals
            break
        case .Dinner:
            self.dinnerMeals = meals
            break
        case .Snack:
            self.snacks = meals
            break
        }

        NutritionManager.nutritionManager.addMacrosFromList(meal: meals)
    }

    func addMacrosFromList(meal : [any Food]){
        for item in meal{
            addMacros(meal: item)
        }
    }
    
    func removeMeal(mealType : MealType, meal : GroceryItem){
        switch mealType{
        case .Breakfast:
            if let index = self.breakfastMeals.firstIndex(where: {$0.id == meal.id}){
                self.breakfastMeals.remove(at: index)
            }
            self.removeMacros(meal: meal)
            break
        case .Lunch:
            if let index = self.lunchMeals.firstIndex(where: {$0.id == meal.id}){
                self.lunchMeals.remove(at: index)
            }
            self.removeMacros(meal: meal)
            break
        case .Dinner:
            if let index = self.dinnerMeals.firstIndex(where: {$0.id == meal.id}){
                self.dinnerMeals.remove(at: index)
            }
            self.removeMacros(meal: meal)
            break
        case .Snack:
            if let index = self.snacks.firstIndex(where: {$0.id == meal.id}){
                self.snacks.remove(at: index)
            }
            self.removeMacros(meal: meal)
            break
        }
    }
    
    func removeMeal(mealType : MealType, meal : Recipe){
        switch mealType{
        case .Breakfast:
            if let index = self.breakfastMeals.firstIndex(where: {$0.id == meal.id}){
                self.breakfastMeals.remove(at: index)
            }
            self.removeMacros(meal: meal)
            break
        case .Lunch:
            if let index = self.lunchMeals.firstIndex(where: {$0.id == meal.id}){
                self.lunchMeals.remove(at: index)
            }
            self.removeMacros(meal: meal)
            break
        case .Dinner:
            if let index = self.dinnerMeals.firstIndex(where: {$0.id == meal.id}){
                self.dinnerMeals.remove(at: index)
            }
            self.removeMacros(meal: meal)
            break
        case .Snack:
            if let index = self.snacks.firstIndex(where: {$0.id == meal.id}){
                self.snacks.remove(at: index)
            }
            self.removeMacros(meal: meal)
            break
        }
    }
}
