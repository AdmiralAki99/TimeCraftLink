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
    
    init(macroColors: [Color]) {
        self.macroColors = macroColors
    }
    
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment:.leading){
                Gauge(value: 90, in: 1...100) {
                    Text("Protein")
                }.gaugeStyle(.accessoryLinearCapacity).tint(self.macroColors[0])
                Text("90/100").font(.caption2).frame(alignment: .trailing)
            }.frame(height: 60).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            VStack(alignment:.leading){
                Gauge(value: 90, in: 1...100) {
                    Text("Carbs")
                }.gaugeStyle(.accessoryLinearCapacity).tint(self.macroColors[1])
                Text("90/100").font(.caption2).frame(alignment: .trailing)
            }.frame(height: 60).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            VStack(alignment: .leading){
                Gauge(value: 90, in: 1...100) {
                    Text("Fat")
                }.gaugeStyle(.accessoryLinearCapacity).tint(self.macroColors[2])
                Text("90/100").font(.caption2).frame(alignment: .trailing)
            }.frame(height: 60).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)).background(Color.gray.opacity(0.2)).cornerRadius(15)
    }
}
