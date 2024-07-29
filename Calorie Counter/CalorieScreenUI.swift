import SwiftUI
import Charts

struct CalorieCounter : View {
    
    @State private var minVal = 0.0
    @State private var maxVal = 100.0
    @State private var currentValue = 100.0
    
    @State private var activities : [ActivityEntry] = [
        .init(name: "Bicycle", value: 500),
        .init(name: "Walking",value:1200),
        .init(name: "Rowing", value: 700),
        .init(name: "Running", value: 800)
    ]
    
    var body: some View {
        VStack{
            VStack{
                Text("Calories").foregroundColor(.white).font(.largeTitle).multilineTextAlignment(.trailing)
                HStack{
                    Gauge(value: currentValue, in: 0...100){
                    }currentValueLabel: {
                        Text("\(Int(currentValue))")
                    }.gaugeStyle(ActivityRingStyle(gradient: [Color.green,Color.blue], width: UIScreen.screenWidth/2.5, height: UIScreen.screenWidth/2.5,title: "Intake")).padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    Gauge(value: currentValue, in: 0...100){
                    }currentValueLabel: {
                        Text("\(Int(currentValue))")
                    }.gaugeStyle(ActivityRingStyle(gradient: [Color.pink,Color.blue], width: UIScreen.screenWidth/2.5, height: UIScreen.screenWidth/2.5,title:"Outtake"))
                }.fixedSize(horizontal: false, vertical: false)
                
            }.fixedSize(horizontal: false, vertical: true).frame(maxHeight: UIScreen.screenHeight/2)
            VStack{
                Text("Activity Stack").foregroundColor(.white).font(.largeTitle)
                VStack(alignment:.leading){
                    GroupBox{
                        Chart(activities){
                            item in BarMark(x:.value("Calories", item.value),y:.value("Activity", item.name),width: .fixed(8))
                                .annotation(position:.trailing){
                                    Text(item.value.formatted())
                                        .foregroundColor(Color.pink)
                                        .font(.caption)
                                }
                            
                        }.fixedSize(horizontal: false, vertical: true)
                            .chartYAxis{
                                AxisMarks(preset:.extended,position:.leading){
                                    _ in AxisValueLabel(horizontalSpacing: 10)
                                        .font(.footnote)
                                }
                            }.foregroundColor(.pink)
                    }
                }
            }.frame(minHeight: UIScreen.screenHeight/2,maxHeight: UIScreen.screenHeight/2)
        }.background(Color.black).frame(maxWidth: .infinity).fixedSize(horizontal: false, vertical: false)
            .preferredColorScheme(.dark)
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
