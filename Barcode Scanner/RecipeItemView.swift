//
//  RecipeItemView.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-26.
//

import Foundation
import UIKit
import SwiftUI

class RecipeItemViewController : UIViewController{
    
    private var recipe: Recipe? = nil
    
    private var nutritionalInfo : RecipeNutritionInfo? = nil
    
    init(recipe: Recipe,nutritionalInfo : RecipeNutritionInfo){
        super.init(nibName: nil, bundle: nil)
        self.recipe = recipe
        self.nutritionalInfo = nutritionalInfo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.overrideUserInterfaceStyle = .dark
        print(self.nutritionalInfo)
        let vc = UIHostingController(rootView: RecipeItemView(recipeItem: recipe!, recipeNutritionalInfo: nutritionalInfo!))
        let recipeView = vc.view!
        recipeView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        view.addSubview(recipeView)
        NSLayoutConstraint.activate([recipeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),recipeView.centerYAnchor.constraint(equalTo: view.centerYAnchor), recipeView.widthAnchor.constraint(equalToConstant: view.bounds.width),recipeView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
}

struct RecipeItemView : View {
    
    private var recipeItem : Recipe
    @State private var recipeNutritionalInfo : RecipeNutritionInfo
    @State private var recipeReveal : Bool = true
    @State private var mealSelection = "Breakfast"
    private let meals =  ["Breakfast","Lunch","Dinner","Snack"]
    
    init(recipeItem: Recipe, recipeNutritionalInfo: RecipeNutritionInfo) {
        self.recipeItem = recipeItem
        self.recipeNutritionalInfo = recipeNutritionalInfo
        
    }
    
    func getNutritionalInfo(){
        DispatchQueue.main.async{
            NutritionManager.nutritionManager.getRecipeNutritionalInfo(with: String(recipeItem.id)) { res in
                switch res{
                case .success(let item):
                    self.recipeNutritionalInfo = item
                case .failure(let error):
                    print("RECIPE VIEW :\(error)")
                }
            }
        }
    }
    
    func getNutrientValueByKey(nutrientKey : String)->Double{
        let nutrient = self.recipeNutritionalInfo.nutrients?.filter({$0.name == nutrientKey}).first
        return nutrient?.amount ?? 0.0
    }
    
    func getNutrientByKey(nutrientKey: String) -> Nutrient?{
        guard let nutrient = self.recipeNutritionalInfo.nutrients?.filter({$0.name == nutrientKey}).first else { return nil }
        return nutrient
    }
    
    var body: some View {
        
        ScrollView{
            AsyncImage(url: URL(string: recipeItem.image ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }.frame(width: UIScreen.screenWidth,height: 300)

            VStack{
                Text(String(recipeItem.title ?? "")).font(.title).bold()
                Text("By: \(String(recipeItem.sourceName ?? ""))")
            }
            HStack{
                VStack(alignment: .center){
                    Label("Prep Mins",systemImage: "clock").padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)).labelStyle(.iconOnly)
                    Text("\(String(recipeItem.preparationMinutes ?? 0)) mins").foregroundColor(Color(UIColor.label))
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                Divider().frame(width: 2,height:50).overlay(Color.pink)
                VStack(alignment: .center){
                    Label("Cooking Mins",systemImage: "oven").labelStyle(.iconOnly)
                    Text("\(String(recipeItem.cookingMinutes ?? 0)) mins").foregroundColor(Color(UIColor.label))
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                Divider().frame(width: 2,height:50).overlay(Color.pink)
                VStack(alignment: .center){
                    Label("Calories",systemImage: "flame.fill").labelStyle(.iconOnly)
                    Text("\(String(recipeNutritionalInfo.calories ?? "")) cal").foregroundColor(Color(UIColor.label)).labelStyle(.iconOnly)
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                Divider().frame(width: 2,height:50).overlay(Color.pink)
                VStack(alignment: .center){
                    Label("Protein",systemImage: "p.circle.fill").labelStyle(.iconOnly)
                    Text(self.recipeNutritionalInfo.protein ?? "")
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }.frame(height: 70,alignment:.center).overlay(RoundedRectangle(cornerRadius: 3).stroke(.pink,lineWidth: 1)).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            VStack{
//                Text(String(htmlText: recipeItem.summary ?? "")).multilineTextAlignment(.leading)
                ExpandSummaryView(text: String(htmlText: recipeItem.summary ?? ""))
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            HStack{
                VStack{
                    Text("Protein").font(.caption)
                    Gauge(value: recipeNutritionalInfo.caloricBreakdown.percentProtein ?? 0.0, in: 1...100) {
                        
                    }.gaugeStyle(.accessoryCircularCapacity).tint(Color.pink)
                }
                Spacer()
                VStack{
                    Text("Carbs").font(.caption)
                    Gauge(value: recipeNutritionalInfo.caloricBreakdown.percentCarbs ?? 0.0, in: 1...100) {
                    }.gaugeStyle(.accessoryCircularCapacity).tint(Color.cyan)
                }
                Spacer()
                VStack{
                    Text("Fat").font(.caption)
                    Gauge(value: recipeNutritionalInfo.caloricBreakdown.percentFat ?? 0.0, in: 1...100) {
                    
                    }.gaugeStyle(.accessoryCircularCapacity).tint(Color.green)
                }
            }.frame(maxWidth: .infinity).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            VStack{
                Text("Percent of Daily Goals").frame(maxWidth: .infinity,alignment: .leading).bold()
                HStack{
                    VStack{
                        Gauge(value: Double(getNutrientValueByKey(nutrientKey: "Protein")/NutritionManager.nutritionManager.getDailyProteinTarget())*100, in: 1...100) {
                            
                        }.gaugeStyle(.accessoryLinearCapacity).tint(Color.pink).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        Text("\(Int(getNutrientValueByKey(nutrientKey: "Protein")/NutritionManager.nutritionManager.getDailyProteinTarget()*100))%").font(.caption)
                        Text("Protein").font(.caption)
                        
                    }
                    Spacer()
                    VStack{
                        Gauge(value: Double(getNutrientValueByKey(nutrientKey: "Carbohydrates")/NutritionManager.nutritionManager.getDailyCarbTarget())*100, in: 1...100) {
                        }.gaugeStyle(.accessoryLinearCapacity).tint(Color.cyan).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        Text("\(Int(getNutrientValueByKey(nutrientKey: "Carbohydrates")/NutritionManager.nutritionManager.getDailyCarbTarget()*100))%").font(.caption)
                        Text("Carbs").font(.caption)
                    }
                    Spacer()
                    VStack{
                        Gauge(value: Double(getNutrientValueByKey(nutrientKey: "Fat")/NutritionManager.nutritionManager.getDailyFatTarget())*100, in: 1...100) {
                        
                        }.gaugeStyle(.accessoryLinearCapacity).tint(Color.green).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        Text("\(Int(getNutrientValueByKey(nutrientKey: "Fat")/NutritionManager.nutritionManager.getDailyFatTarget()*100))%").font(.caption)
                        Text("Fat").font(.caption)
                    }
                    Spacer()
                    VStack{
                        Gauge(value: Double(getNutrientValueByKey(nutrientKey: "Calories")/NutritionManager.nutritionManager.getCaloricalDailyTarget())*100, in: 1...100) {
                        
                        }.gaugeStyle(.accessoryLinearCapacity).tint(Color.purple).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        Text("\(Int(getNutrientValueByKey(nutrientKey: "Calories")/NutritionManager.nutritionManager.getCaloricalDailyTarget()*100))%").font(.caption)
                        Text("Calories").font(.caption)
                    }
                }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            VStack{
                ForEach(recipeItem.extendedIngredients ?? [],id:\.id) { item in
                    RecipeIngredientCell(recipeIngredient: item)
                }
            }.foregroundColor(Color(UIColor.label)).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            VStack{
                ForEach(recipeItem.analyzedInstructions?.first?.steps ?? [],id:\.number) { item in
                    RecipeInstructionCell(recipeStep : item)
                }
            }.foregroundColor(Color(UIColor.label)).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }.onAppear(){
        }
    }
}
