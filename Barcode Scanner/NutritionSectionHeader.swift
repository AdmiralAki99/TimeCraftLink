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
    
    init(macroColors: [Color]) {
        self.macroColors = macroColors
    }
    
    var body: some View {
        HStack{
            Text("Title").frame(maxWidth: .infinity,alignment: .leading).foregroundColor(Color(UIColor.label)).bold()
            HStack{
                Text("P").font(.caption2).background(Circle().fill(macroColors[0]).frame(width: 13,height: 13)).foregroundColor(Color.white)
                Text("15")
                Spacer()
                Text("C").font(.caption2).background(Circle().fill(macroColors[1]).frame(width: 13,height: 13)).foregroundColor(Color.white)
                Text("15")
                Spacer()
                Text("F").font(.caption2).background(Circle().fill(macroColors[2]).frame(width: 13,height: 13)).foregroundColor(Color.white)
                Text("15")
                Spacer()
                Text("474 Cal").bold().lineLimit(1)
            }
        }.background(Color.clear)
    }
}
