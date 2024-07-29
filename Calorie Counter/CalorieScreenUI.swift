import SwiftUI

struct CalorieCounter : View {
    
    @State private var minVal = 0.0
    @State private var maxVal = 100.0
    @State private var currentValue = 70.0
    
    var body: some View {
        VStack{
            Gauge(value: currentValue, in: 0...100){
            }currentValueLabel: {
                Text("\(Int(currentValue))")
            }.gaugeStyle(ActivityRingStyle(gradient: [Color.green,Color.blue], width: 300, height: 300))
        }
    }
}
