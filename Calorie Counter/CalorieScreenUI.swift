import SwiftUI
import Charts
import UIKit

import UIKit

class ActivityScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .dark
        let vc = UIHostingController(rootView: CalorieCounter())
        let calorieView = vc.view!
        calorieView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(vc)
        view.addSubview(calorieView)
        view.backgroundColor = .black
        
        // Center the screen
        NSLayoutConstraint.activate([calorieView.centerXAnchor.constraint(equalTo: view.centerXAnchor),calorieView.centerYAnchor.constraint(equalTo: view.centerYAnchor), calorieView.widthAnchor.constraint(equalToConstant: view.bounds.width),calorieView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
        
        vc.didMove(toParent: self)
        
        let watchBarButton = UIBarButtonItem(title: "Back",image: UIImage(systemName: "carrot.fill"), target: self, action: #selector(scanBarcode))
        watchBarButton.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItem = watchBarButton
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func scanBarcode(){
        navigationController?.overrideUserInterfaceStyle = .dark
        navigationController?.pushViewController(NutritionScreenViewController(), animated: true)
    }
    
}
struct CalorieCounter : View {
    
    @State private var minVal = 0.0
    @State private var maxVal = 3000.0
    @State private var currentValue = 2200.0
    
    @State private var healthKitManager : HealthKitManager = HealthKitManager.healthKit
    
    @State private var activities : [ActivityEntry] = []
    
    @State private var nutrition : [NutrionalInformation] = []
    
    @State private var navigationLinkSelector : Int? = 0
    
    func initializeData(){
        self.activities = [
            .init(name: "Bicycle", value: 500),
            .init(name: "Walking",value:Double(healthKitManager.sumWalkingRunningDistance())),
            .init(name: "Rowing", value: 700),
            .init(name: "Running", value: 800)]
        self.nutrition = [
            .init(name: "Carbohydrates", value: healthKitManager.getUserNutritionalCarbohydrate()),
            .init(name: "Protein",value: 150),
            .init(name: "Fat",value: 25)
        ]
    }
    
    var body: some View {
        
        VStack{
            Text("Activity").foregroundColor(Color(UIColor.label)).font(.largeTitle).multilineTextAlignment(.trailing)
            HStack{
                Gauge(value: currentValue, in: 0...maxVal){
                }currentValueLabel: {
                    Text("\(Int(currentValue))")
                }.gaugeStyle(ActivityRingStyle(gradient: [Color.green,Color.blue], width: UIScreen.screenWidth/2.5, height: UIScreen.screenWidth/2.5,title: "Intake",color: UIColor.label)).padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                Gauge(value: currentValue, in: 0...maxVal){
                }currentValueLabel: {
                    Text("\(Int(currentValue))")
                }.gaugeStyle(ActivityRingStyle(gradient: [Color.pink,Color.blue], width: UIScreen.screenWidth/2.5, height: UIScreen.screenWidth/2.5,title:"Outtake",color: UIColor.label))
            }.fixedSize(horizontal: false, vertical: false)

        }.fixedSize(horizontal: false, vertical: true).frame(maxHeight: UIScreen.screenHeight/2)
        VStack{
            Text("Activity Stack").foregroundColor(Color(UIColor.label)).font(.largeTitle)
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
                }.background(.black)
                GroupBox{
                    Chart(nutrition){
                        item in BarMark(x:.value("g", item.value),y:.value("Group", item.name)).foregroundStyle(by: .value("Group", item.name)).annotation(position:.overlay){
                            Text("\(Int(item.value))").font(.caption.bold())
                        }
                    }.chartYAxis{
                        AxisMarks(preset: .extended, position: .leading){
                            _ in AxisValueLabel(horizontalSpacing: 10).font(.footnote)
                        }
                    }
                }
            }
        }.frame(maxWidth: .infinity).fixedSize(horizontal: false, vertical: false)
            .preferredColorScheme(.dark).onAppear(){self.initializeData()}
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
