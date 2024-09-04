//
//  GroceryItemView.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-15.
//

import Foundation
import SwiftUI
import Charts

class GroceryItemViewController : UIViewController{
    
    lazy var foodItem : GroceryItem? = nil
    @StateObject var nutritionManager = DataManager.data_manager
    
    init(foodItem: GroceryItem) {
        super.init(nibName: nil, bundle: nil)
        self.foodItem = foodItem
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        
        view.overrideUserInterfaceStyle = .dark
        
        let vc = UIHostingController(rootView: GroceryItemView(scannedFood: foodItem!))
        let foodView = vc.view!
        foodView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        view.addSubview(foodView)
        
        NSLayoutConstraint.activate([foodView.centerXAnchor.constraint(equalTo: view.centerXAnchor),foodView.centerYAnchor.constraint(equalTo: view.centerYAnchor), foodView.widthAnchor.constraint(equalToConstant: view.bounds.width),foodView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct GroceryItemView : View {
    let scannedFood : GroceryItem
    
    init(scannedFood: GroceryItem) {
        self.scannedFood = scannedFood
    }
    
    var body: some View {
        VStack{
            VStack{
                Text(String(scannedFood.title ?? "")).foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .leading).padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                HStack{
                    VStack{
                        Text("Protein").font(.caption)
                        Gauge(value: scannedFood.nutrition?.caloricBreakdown.percentProtein ?? 0.0, in: 1...100) {
                            
                        }.gaugeStyle(.accessoryCircularCapacity).tint(Color.pink)
                    }
                    Spacer()
                    VStack{
                        Text("Carbs").font(.caption)
                        Gauge(value: scannedFood.nutrition?.caloricBreakdown.percentCarbs ?? 0.0, in: 1...100) {
                        }.gaugeStyle(.accessoryCircularCapacity).tint(Color.cyan)
                    }
                    Spacer()
                    VStack{
                        Text("Fat").font(.caption)
                        Gauge(value: scannedFood.nutrition?.caloricBreakdown.percentFat ?? 0.0, in: 1...100) {
                        
                        }.gaugeStyle(.accessoryCircularCapacity).tint(Color.green)
                    }
                }.frame(maxWidth: .infinity).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
            GroceryItemNutrientsView(foodItem: scannedFood).padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
        }
    }
}

struct GroceryItemNutrientsView : View {
    private let foodItem : GroceryItem
    @State private var mealSelection = "Breakfast"
    private let meals =  ["Breakfast","Lunch","Dinner","Snack"]

    
    init(foodItem:GroceryItem) {
        self.foodItem = foodItem
    }
    
    func getNutrientValueByKey(nutrientKey : String)->Double{
        let nutrient = self.foodItem.nutrition?.nutrients.filter({$0.name == nutrientKey}).first
        return nutrient?.amount ?? 0.0
    }
    
    func getNutrientByKey(nutrientKey: String) -> Nutrient?{
        guard let nutrient = self.foodItem.nutrition?.nutrients.filter({$0.name == nutrientKey}).first else { return nil }
        return nutrient
    }
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("Serving Size").frame(maxWidth: .infinity,alignment: .leading).bold()
                    Text(String(foodItem.servings?.raw ?? "")).bold().frame(maxWidth: .infinity,alignment: .trailing)
                }
                HStack{
                    Text("Number of Servings").frame(maxWidth: .infinity,alignment: .leading).bold()
                    Text("1").frame(maxWidth: .infinity,alignment: .trailing).bold()
                }
                HStack{
                    Text("Calories").frame(maxWidth: .infinity,alignment: .leading).bold()
                    Text("\(Int(foodItem.nutrition?.calories ?? 0.0))").bold().frame(maxWidth: .infinity,alignment: .trailing)
                }
            }
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
                Text("Nutritional Info.").font(.title).bold().foregroundColor(Color(UIColor.label)).frame(maxWidth: .infinity,alignment: .leading)
                HStack{
                    Text("Total Fat \(Int(getNutrientValueByKey(nutrientKey:"Fat")))\(getNutrientByKey(nutrientKey:"Fat")?.unit ?? "")").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .leading)
                    Text("\(Int(getNutrientByKey(nutrientKey:"Fat")?.percentOfDailyNeeds ?? 0.0))%").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .trailing)
                }
                Divider().frame(height: 1).overlay(Color.white).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                HStack{
                    Text("Saturated Fat").foregroundColor(Color(UIColor.secondaryLabel)).bold().frame(maxWidth: .infinity,alignment: .leading)
                    Text("\(Int(getNutrientByKey(nutrientKey:"Saturated Fat")?.percentOfDailyNeeds ?? 0.0))%").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .trailing)
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                Divider().frame(height: 1).overlay(Color.white).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                HStack{
                    Text("Trans Fat").foregroundColor(Color(UIColor.secondaryLabel)).bold().frame(maxWidth: .infinity,alignment: .leading)
                    Text("\(Int(getNutrientByKey(nutrientKey:"Trans Fat")?.percentOfDailyNeeds ?? 0.0))%").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .trailing)
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                HStack{
                    Text("Cholesterol \(Int(getNutrientValueByKey(nutrientKey:"Cholesterol")))\(getNutrientByKey(nutrientKey:"Cholesterol")?.unit ?? "")").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .leading)
                    Text("\(Int(getNutrientByKey(nutrientKey:"Cholesterol")?.percentOfDailyNeeds ?? 0.0))%").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .trailing)
                }
                Divider().frame(height: 1).overlay(Color.white)
                HStack{
                    Text("Sodium \(Int(getNutrientValueByKey(nutrientKey:"Sodium")))\(getNutrientByKey(nutrientKey:"Sodium")?.unit ?? "")").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .leading)
                    Text("\(Int(getNutrientByKey(nutrientKey:"Sodium")?.percentOfDailyNeeds ?? 0.0))%").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .trailing)
                    
                }
                Divider().frame(height: 1).overlay(Color.white)
                HStack{
                    Text("Total Carbohydrate \(Int(getNutrientValueByKey(nutrientKey:"Carbohydrates")))\(getNutrientByKey(nutrientKey:"Carbohydrates")?.unit ?? "")").foregroundColor(Color(UIColor.label)).bold().fixedSize().frame(maxWidth: .infinity,alignment: .leading)
                    Text("\(Int(getNutrientByKey(nutrientKey:"Carbohydrates")?.percentOfDailyNeeds ?? 0.0))%").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .trailing)
                    
                }
                Divider().frame(height: 1).overlay(Color.white)
                HStack{
                    Text("Protein \(Int(getNutrientValueByKey(nutrientKey:"Protein")))\(getNutrientByKey(nutrientKey:"Protein")?.unit ?? "")").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .leading)
                }
            }.frame(maxWidth: .infinity)
        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}

