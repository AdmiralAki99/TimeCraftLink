//
//  FoodItem.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-09.
//

import Foundation
import SwiftUI
import Charts

struct FoodItemListCell : View {
    
    private let navigationController : UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var body: some View {
        HStack{
            VStack{
                Text("Title")
                Text("Subtitle").font(.caption)
            }
            Button(){
                navigationController.pushViewController(FoodItemViewController(), animated: true)
            }label: {
                Label(
                    title: { Text("") },
                    icon: { Image(systemName: "chevron.right").foregroundColor(Color(UIColor.label)) }
                )
            }.frame(maxWidth: .infinity,alignment: .trailing).controlSize(.small).frame(maxWidth: .infinity,alignment: .trailing)
        }
    }
}

class FoodItemViewController : UIViewController{
    
    
    override func viewDidLoad() {
        view.overrideUserInterfaceStyle = .dark
        
        let vc = UIHostingController(rootView: FoodItemView())
        let foodView = vc.view!
        foodView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        view.addSubview(foodView)
        
        NSLayoutConstraint.activate([foodView.centerXAnchor.constraint(equalTo: view.centerXAnchor),foodView.centerYAnchor.constraint(equalTo: view.centerYAnchor), foodView.widthAnchor.constraint(equalToConstant: view.bounds.width),foodView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct FoodItemView : View {
    var body: some View {
        ScrollView{
            VStack{
                VStack{
                    Text("Title").foregroundColor(Color(UIColor.label)).font(.largeTitle).bold()
                    Text("Subtitle").foregroundColor(Color(UIColor.secondaryLabel)).font(.title3).bold().padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                }.frame(maxWidth: .infinity,alignment: .leading).padding(EdgeInsets(top: 20, leading: 10, bottom: 5, trailing: 10))
               
                HStack{
                    Chart{
                        BarMark(x: .value("Nutrient", "Protien"), y: .value("Value", 50)).annotation(){
                            Text("50")
                                .foregroundColor(Color.pink)
                                .font(.caption)
                        }.foregroundStyle(.pink).clipShape(Capsule())
                        BarMark(x: .value("Nutrient", "Carbs"), y: .value("Value", 20)).annotation(){
                            Text("20")
                                .foregroundColor(Color.cyan)
                                .font(.caption)
                        }.foregroundStyle(.cyan).clipShape(Capsule())
                        BarMark(x: .value("Nutrient", "Fat"), y: .value("Value", 30)).annotation(){
                            Text("30")
                                .foregroundColor(Color.green)
                                .font(.caption)
                        }.foregroundStyle(.green).clipShape(Capsule())
                    }.frame(height:UIScreen.screenHeight/3).padding()
                        .chartXAxis {
                        AxisMarks(position: .automatic){ _ in
                            AxisGridLine().foregroundStyle(.clear)
                            AxisTick().foregroundStyle(.clear)
                            AxisValueLabel().foregroundStyle(.white)
                        }
                    }.chartYAxis {
                        AxisMarks(position: .automatic){ _ in
                            AxisGridLine().foregroundStyle(.clear)
                            AxisTick().foregroundStyle(.clear)
                        }
                    }
                        .chartLegend(position: .trailing,alignment: .top)
                }.background(Color.gray.opacity(0.2)).cornerRadius(15).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                // Add Nutrient View Right Here
            }
        }
    }
}

struct NutrientsView : View {
    private let servingSize : Double
    private let servingUnits : String
    private var nutrients : [Nutritent]
    
    init(servingSize: Double, servingUnits: String, nutrients: [Nutritent]) {
        self.servingSize = servingSize
        self.servingUnits = servingUnits
        self.nutrients = nutrients
    }
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("Serving Size").frame(maxWidth: .infinity,alignment: .leading)
                    Text("\(servingUnits)").frame(maxWidth: .infinity,alignment: .trailing)
                }
                HStack{
                    Text("Calories").frame(maxWidth: .infinity,alignment: .leading)
                    Text("160").frame(maxWidth: .infinity,alignment: .trailing)
                }
            }
            List(nutrients){nutrient in
                Text(nutrient.nutrientName).foregroundColor(Color(UIColor.secondaryLabel)).font(.caption2)
            }
        }
    }
}

class FoodItemScannedViewController : UIViewController{
    
    var scannedFoodItem : Food?
    
    init(scannedFoodItem: Food) {
        super.init(nibName: nil, bundle: nil)
        self.scannedFoodItem = scannedFoodItem
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        view.overrideUserInterfaceStyle = .dark
        
        let vc = UIHostingController(rootView: FoodScannedItemView(scannedFood: scannedFoodItem!))
        let foodView = vc.view!
        foodView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        view.addSubview(foodView)
        
        NSLayoutConstraint.activate([foodView.centerXAnchor.constraint(equalTo: view.centerXAnchor),foodView.centerYAnchor.constraint(equalTo: view.centerYAnchor), foodView.widthAnchor.constraint(equalToConstant: view.bounds.width),foodView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct FoodScannedItemView : View {
    @State var scannedFood : Food
    
    init(scannedFood: Food) {
        self.scannedFood = scannedFood
    }
    
    var body: some View {
        VStack{
            VStack{
                Text("\(scannedFood.ingredients)").foregroundColor(Color(UIColor.label)).bold().frame(maxWidth: .infinity,alignment: .leading).padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
//                Text("Subtitle").foregroundColor(Color(UIColor.secondaryLabel)).font(.title3).bold().padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                HStack{
                    Gauge(value: 90, in: 1...100) {
                        
                    }.gaugeStyle(.accessoryCircularCapacity).tint(Color.pink)
                    Gauge(value: 90, in: 1...100) {
                        
                    }.gaugeStyle(.accessoryCircularCapacity).tint(Color.cyan)
                    Gauge(value: 90, in: 1...100) {
                        
                    }.gaugeStyle(.accessoryCircularCapacity).tint(Color.green)
                }.tint(Color.clear).cornerRadius(15).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)).frame(width: .infinity)
                NutrientsView(servingSize: self.scannedFood.servingSize,servingUnits: self.scannedFood.householdServingFullText,nutrients: self.scannedFood.foodNutrients).padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
            }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        }
    }
}
