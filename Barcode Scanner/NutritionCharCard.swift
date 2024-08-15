//
//  NutritionCharCard.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-08.
//

import Foundation
import SwiftUI
import Charts

struct NutritionChartCard : View {
    
    @State private var caloricalIntake : Double = NutritionManager.nutritionManager.getDailyCaloricalIntake()
    
    var body: some View {
        HStack{
            VStack{
                Text("Remaining").font(.title3).foregroundColor(Color(UIColor.label).opacity(0.2))
                Text("\(Int(NutritionManager.nutritionManager.getRemainingCalories())) cal").font(.title)
            }
            Gauge(value: NutritionManager.nutritionManager.getRemainingCalories(), in: 1...NutritionManager.nutritionManager.getCaloricalDailyTarget()) {
                
            }.gaugeStyle(.accessoryCircularCapacity).tint(Color.pink).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 5))
            Divider().frame(width: 1).overlay(Color.white)
            VStack{
                VStack{
                    Text("Consumed").font(.subheadline)
                    Text("\(Int(NutritionManager.nutritionManager.getDailyCaloricalIntake())) cal")
                }
                VStack{
                    Text("Workouts").font(.subheadline)
                    Text("0 cal")
                }
            }
        }.onAppear(){
            self.caloricalIntake = NutritionManager.nutritionManager.getDailyCaloricalIntake()
        }
    }
}
