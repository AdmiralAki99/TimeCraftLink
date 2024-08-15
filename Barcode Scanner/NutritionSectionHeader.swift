//
//  NutritionSectionHeader.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-09.
//

import Foundation
import SwiftUI

struct NutiritionSectionHeader : View {
    private var macroColors : [Color]
    private var title : String
    @State private var proteinIntake : Double = NutritionManager.nutritionManager.getDailyProteinIntake()
    @State private var carbIntake : Double = NutritionManager.nutritionManager.getDailyCarbIntake()
    @State private var fatIntake : Double = NutritionManager.nutritionManager.getDailyFatIntake()
    
    init(macroColors : [Color],title:String){
        self.macroColors = macroColors
        self.title = title
    }
    
    var body: some View {
        HStack{
            Text("\(title)").fixedSize().frame(maxWidth: .infinity,alignment: .leading).foregroundColor(Color(UIColor.label)).bold()
            HStack{
                Text("P").fixedSize().font(.caption2).background(Circle().fill(macroColors[0]).frame(width: 13,height: 13)).foregroundColor(Color.white)
                if title == "Breakfast"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Breakfast, macroType: .Protein)))").fixedSize()
                }else if title == "Lunch"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Lunch, macroType: .Protein)))").fixedSize()
                }else if title == "Dinner"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Dinner, macroType: .Protein)))").fixedSize()
                }else if title == "Snack"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Snack, macroType: .Protein)))").fixedSize()
                }
                Spacer()
                Text("C").fixedSize().font(.caption2).background(Circle().fill(macroColors[1]).frame(width: 13,height: 13)).foregroundColor(Color.white)
                if title == "Breakfast"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Breakfast, macroType: .Carbs)))").fixedSize()
                }else if title == "Lunch"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Lunch, macroType: .Carbs)))").fixedSize()
                }else if title == "Dinner"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Dinner, macroType: .Carbs)))").fixedSize()
                }else if title == "Snack"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Snack, macroType: .Carbs)))").fixedSize()
                }
                Spacer()
                Text("F").fixedSize().font(.caption2).background(Circle().fill(macroColors[2]).frame(width: 13,height: 13)).foregroundColor(Color.white)
                if title == "Breakfast"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Breakfast, macroType: .Fat)))").fixedSize()
                }else if title == "Lunch"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Lunch, macroType: .Fat)))").fixedSize()
                }else if title == "Dinner"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Dinner, macroType: .Fat)))").fixedSize()
                }else if title == "Snack"{
                    Text("\(Int(NutritionManager.nutritionManager.getMealMacros(mealType: .Snack, macroType: .Fat)))").fixedSize()
                }
                Spacer()
                Text("474 Cal").fixedSize().lineLimit(1)
            }
        }.background(Color.clear)
    }
}
