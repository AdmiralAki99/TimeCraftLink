//
//  StackedRingView.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-09-09.
//

import Foundation
import SwiftUI

struct StackedRingView : View {
    
    @StateObject private var todoListManager = ToDoListManager.toDoList_manager
    @State private var colors : [Color]
    @State private var categoryPercentages : [Double] = ToDoListManager.toDoList_manager.getCategoryCompletedInfo()
    @State private var categoryLabels : [String] = ToDoListManager.toDoList_manager.getCategoryLabels()
    
    init(colors: [Color], categoryPercentages: [Double], categoryLabels: [String]) {
        self.colors = colors
    }
    
    var body: some View {
        HStack{
            StackedRings(colors: colors, categoryPercentages: todoListManager.getCategoryCompletedInfo(), categoryLabels: todoListManager.getCategoryLabels()).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            Spacer()
            StackedLabels(colors: colors, categoryLabels: categoryLabels, categoryPercentages: categoryPercentages)
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)).onAppear(){
            self.categoryLabels = todoListManager.getCategoryLabels()
            self.categoryPercentages = todoListManager.getCategoryCompletedInfo()
        }
    }
}

struct StackedRings : View {
    
    @StateObject private var todoListManager = ToDoListManager.toDoList_manager
    @State private var colors : [Color]
    @State private var categoryPercentages : [Double]
    @State private var categoryLabels : [String]
    
    @State private var circles : [(any View,any View)] = []
    private var largestCircleSize : Double = 150.0
    private var circleDifference : Double = 30.0
    
    init(colors: [Color], categoryPercentages: [Double], categoryLabels: [String]) {
        self.colors = colors
        self.categoryPercentages = categoryPercentages
        self.categoryLabels = categoryLabels
    }
    
    var body: some View {
        ZStack{
            ForEach(0...self.categoryPercentages.count-1,id: \.self){ index in
                Circle().stroke(Color.gray.opacity(0.3),lineWidth: 5).frame(width: largestCircleSize - (Double(index) * circleDifference),height: largestCircleSize - (Double(index) * circleDifference))
                Circle().trim(from: 0, to: self.todoListManager.getCategoryCompletedInfo()[index]).stroke(AngularGradient(gradient: Gradient(colors: [colors[index].darken(),colors[index]]), center: .center,startAngle: .degrees(0),endAngle: .degrees(360)),style: StrokeStyle(lineWidth: 8,lineCap: .round)).frame(width: largestCircleSize - (Double(index) * circleDifference),height: largestCircleSize - (Double(index) * circleDifference)).rotationEffect(.degrees(-90))
            }
        }.onAppear(){
        }
    }
}

struct StackedLabels : View {
    
    @State private var colors : [Color]
    @State private var categoryLabels : [String]
    @State private var categoryPercentages : [Double]
    
    init(colors: [Color], categoryLabels: [String], categoryPercentages: [Double]) {
        self.colors = colors
        self.categoryLabels = categoryLabels
        self.categoryPercentages = categoryPercentages
    }
    
    var body: some View {
        VStack(alignment:.leading){
            ForEach(0...categoryLabels.count-1,id: \.self){ index in
                HStack{
                    Circle().stroke(colors[index],lineWidth: 2).fill(colors[index]).frame(width: 5,height: 5)
                    Text(categoryLabels[index])
                    Spacer()
                    Text("\(String(Int(categoryPercentages[index] * 100)))%")
                }
            }
        }
    }
}

extension Color{
    func darken()-> Color{
        return self.opacity(0.7)
    }
}
