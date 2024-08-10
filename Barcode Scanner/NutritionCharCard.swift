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
    
    var body: some View {
        HStack{
            VStack{
                Text("Remaining").font(.title3).foregroundColor(Color(UIColor.label).opacity(0.2))
                Text("900 cal").font(.title)
            }
            Gauge(value: 90, in: 1...100) {
                
            }.gaugeStyle(.accessoryCircularCapacity).tint(Color.pink).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 5))
            Divider().frame(width: 1).overlay(Color.white)
            VStack{
                VStack{
                    Text("Consumed").font(.subheadline)
                    Text("1000 cal")
                }
                VStack{
                    Text("Workouts").font(.subheadline)
                    Text("0 cal")
                }
            }
        }
    }
}
