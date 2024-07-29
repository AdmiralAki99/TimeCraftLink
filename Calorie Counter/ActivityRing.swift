import SwiftUI

struct ActivityRingStyle: GaugeStyle{
    @State private var gradient : LinearGradient!
    
    @State private var width : CGFloat
    @State private var height : CGFloat
    @State private var title : String
    
    init(gradient: [Color], width: CGFloat, height: CGFloat,title:String) {
        self.gradient = LinearGradient(colors: gradient,startPoint: .trailing, endPoint: .leading)
        self.width = width
        self.height = height
        self.title = title
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            Circle().foregroundColor(.clear)
            Circle().trim(from: 0,to:0.75*configuration.value).stroke(gradient,lineWidth:15).rotationEffect(.degrees(135))
            Circle().trim(from: 0.0,to: 0.75).stroke(Color.black,style: StrokeStyle(lineWidth: 10,lineCap: .butt,lineJoin: .round,dash: [0,34],dashPhase: 0.0)).rotationEffect(.degrees(135))
            VStack{
                configuration.currentValueLabel.font(.system(size: 70,weight: .bold,design: .rounded)).foregroundColor(.white)
                Text("\(title)").font(.system(.body,design: .rounded)).bold().foregroundColor(.white)
            }
        }.frame(width: self.width,height: self.height)
    }
    
}
