//
//  NutritentMacroTracker.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-09.
//

import Foundation
import SwiftUI
import Charts

struct NutrientMacroTracker : View {
    
    private var macroColors : [Color]
    @State private var proteinIntake : Double = NutritionManager.nutritionManager.getDailyProteinIntake()
    @State private var carbIntake : Double = NutritionManager.nutritionManager.getDailyCarbIntake()
    @State private var fatIntake : Double = NutritionManager.nutritionManager.getDailyFatIntake()
    
    init(macroColors: [Color]) {
        self.macroColors = macroColors
    }
    
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment:.leading){
                Gauge(value: self.proteinIntake, in: 0...NutritionManager.nutritionManager.getDailyProteinTarget()) {
                    Text("Protein")
                }.gaugeStyle(.accessoryLinearCapacity).tint(self.macroColors[0])
                Text("\(Int(self.proteinIntake))/\(Int(NutritionManager.nutritionManager.getDailyProteinTarget()))").font(.caption2).frame(alignment: .trailing)
            }.frame(height: 60).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            VStack(alignment:.leading){
                Gauge(value: self.carbIntake, in: 0...NutritionManager.nutritionManager.getDailyCarbTarget()) {
                    Text("Carbs")
                }.gaugeStyle(.accessoryLinearCapacity).tint(self.macroColors[1])
                Text("\(Int(self.carbIntake))/\(Int(NutritionManager.nutritionManager.getDailyCarbTarget()))").font(.caption2).frame(alignment: .trailing)
            }.frame(height: 60).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            VStack(alignment: .leading){
                Gauge(value: self.fatIntake, in: 0...NutritionManager.nutritionManager.getDailyFatTarget()) {
                    Text("Fat")
                }.gaugeStyle(.accessoryLinearCapacity).tint(self.macroColors[2])
                Text("\(Int(self.fatIntake))/\(Int(NutritionManager.nutritionManager.getDailyFatTarget()))").font(.caption2).frame(alignment: .trailing)
            }.frame(height: 60).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)).background(Color.gray.opacity(0.2)).cornerRadius(15).onAppear(){
            self.proteinIntake = NutritionManager.nutritionManager.getDailyProteinIntake()
            self.carbIntake = NutritionManager.nutritionManager.getDailyCarbIntake()
            self.fatIntake = NutritionManager.nutritionManager.getDailyFatIntake()
        }
    }
}
