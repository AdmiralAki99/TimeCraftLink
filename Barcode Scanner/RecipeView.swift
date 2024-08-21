//
//  RecipeView.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-20.
//

import Foundation
import SwiftUI

class RecipeViewController : UIViewController{
    
    private var recipe: Recipe = {
        return Recipe(id: 0, vegetarian: nil, vegan: nil, glutenFree: nil, dairyFree: nil, preparationMinutes: nil, cookingMinutes: nil, extendedIngredients: nil, nutrition: nil, analyzedInstructions: nil,title: nil, readyInMinutes: nil,servings:nil,summary: nil,sourceUrl: nil, sourceName: nil)
    }()
    
    init(recipe: Recipe){
        super.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.overrideUserInterfaceStyle = .dark
        
        let vc = UIHostingController(rootView: RecipeView(recipeItem: recipe))
        let recipeView = vc.view!
        recipeView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        view.addSubview(recipeView)
        
        NSLayoutConstraint.activate([recipeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),recipeView.centerYAnchor.constraint(equalTo: view.centerYAnchor), recipeView.widthAnchor.constraint(equalToConstant: view.bounds.width),recipeView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct RecipeView : View {
    
    private var recipeItem : Recipe
    @State private var recipeNutritionalInfo : RecipeNutritionInfo?
    
    init(recipeItem: Recipe) {
        self.recipeItem = recipeItem
        getNutritionalInfo()
    }
    
    func getNutritionalInfo(){
        DispatchQueue.main.async{
            NutritionManager.nutritionManager.getRecipeNutritionalInfo(with: String(recipeItem.id)) { res in
                switch res{
                case .success(let item):
                    print(item)
                    self.recipeNutritionalInfo = item
                    break
                case .failure(let error):
                    print("RECIPE VIEW :\(error)")
                }
            }
        }
    }
    
    var body: some View {
        VStack{
            Text(String(recipeItem.title ?? "")).font(.title).bold()
            Text("By: \(String(recipeItem.title ?? ""))")
        }
        HStack{
            Label("\(String(recipeItem.cookingMinutes ?? 0)) mins",systemImage: "clock")
            Spacer()
            Label("\(String(recipeItem.cookingMinutes ?? 0)) mins",systemImage: "clock")
        }
        
    }
}

