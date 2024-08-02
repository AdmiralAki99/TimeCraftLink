import Foundation
import HealthKit

class HealthKitManager : ObservableObject{
    static let healthKit = HealthKitManager()
    
    var healthStore = HKHealthStore()
    
    var totalWeeklyStepCount : Int = 0
    var userWeeklySteps : [Int:Int] = [1:0,2:0,3:0,4:0,5:0,6:0,7:0]
    
    var intakeCalories : Double = 0.0
    var burntCalories : Double = 0.0
    
    init(){
        self.getAuthorization()
    }
    //MARK: Function To Get Authorization
    func getAuthorization(){
        let permissions = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        ])
        
        guard HKHealthStore.isHealthDataAvailable() else{
            print("Health Data Cannot be fetched")
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: permissions) { res, err in
            if res{
                self.getWeeklySteps()
                self.getMetrics()
            }else{
                print("Error: \(String(describing: err))")
            }
        }
    }
    
    func getData(){
        
    }
    
    func getWeeklySteps(){
        // Define type of quantity being measured
        guard let typ = HKQuantityType.quantityType(forIdentifier: .stepCount) else{
            return
        }
        
        let cal = Calendar.current
        let dayOne = Date()
        
        guard let start = Calendar.current.date(from: cal.dateComponents([.yearForWeekOfYear,.weekOfYear], from: dayOne)) else{
            return
        }
        
        guard let end = Calendar.current.date(byAdding: .day, value: 6, to: start) else{
            return
        }
        
        let searchCond = HKQuery.predicateForSamples(withStart: start, end: end,options: .strictStartDate)
        
        let searchQuery = HKStatisticsCollectionQuery(quantityType: typ, quantitySamplePredicate: searchCond, options: .cumulativeSum, anchorDate: start, intervalComponents: DateComponents(day:1))
        
        searchQuery.initialResultsHandler = {
            _,res,err in
            
            guard let stat = res else{
                if let err = err{
                    print("Error: \(err.localizedDescription)")
                }
                return
            }
            
            stat.enumerateStatistics(from: start, to: end) { stats, _ in
                if let quantity = stats.sumQuantity(){
                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                    let day = cal.component(.weekday, from: stats.startDate)
                    self.userWeeklySteps[day] = steps
                }
            }
        }
        self.healthStore.execute(searchQuery)
        print("Weekly steps: \(self.userWeeklySteps)")
    }
    
    func getMetrics(){
        self.totalWeeklyStepCount = getTotalWeeklyStepCount()
    }
    
    func getTotalWeeklyStepCount()->Int{
        return 50
    }
}
