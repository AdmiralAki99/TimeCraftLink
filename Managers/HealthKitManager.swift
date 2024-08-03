import Foundation
import HealthKit

class HealthKitManager : ObservableObject{
    static let healthKit = HealthKitManager()
    
    private let healthStore : HKHealthStore?
    
    private var totalWeeklyStepCount : Int = 0
    private var userWeeklySteps : [Int:Int] = [:]
    private var temp : [Int] = []
    private var quantityInfo : Set<HKObjectType> = Set([
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
        HKObjectType.quantityType(forIdentifier: .dietaryProtein)!
    ])
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            // Health Data is available
            healthStore = HKHealthStore()
            requestReadPermission(quantities: self.quantityInfo)
        }else{
            // No health data is available so we need to make the store nil. Essentially making this manager useless
            healthStore = nil
        }
    }
    
    func requestReadPermission(quantities: Set<HKObjectType>){
        self.healthStore?.requestAuthorization(toShare: nil, read: quantities, completion: { res, err in
            if res{
                self.getStepsSample()
            }else{
                
            }
        })
    }
    
    func getStepsSample(){
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .stepCount) else{
            return
        }
        
        let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))
        
        let endDate = Calendar.current.date(byAdding: .day,value: 6, to: Date())
        
        let healthKitPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate,options: .strictStartDate)
        
        let searchQuery = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: healthKitPredicate,options: .cumulativeSum, anchorDate: startDate!, intervalComponents: DateComponents(day: 1))
        
        // Initial Query Call
        
        searchQuery.initialResultsHandler = {query,stats,err in
            if let stats = stats{
                DispatchQueue.main.async{
                    var data = []
                    stats.enumerateStatistics(from: startDate! ,to: endDate!) { stats, _ in
                        print("Value: \(Int(stats.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0))")
                    }
                }
            }
        }
        
        // Backgorund Query Call For Updating Records
        searchQuery.statisticsUpdateHandler = {query,statistics,statisticsCollection,error in
            DispatchQueue.main.async{
                statisticsCollection?.enumerateStatistics(from: startDate!, to: endDate!, with: { stats, _ in
                     print("Update: \(Int(stats.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0))")
                })
            }
        }
        
        healthStore?.execute(searchQuery)
    }
    
    func getDistanceCycledSample(){
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .distanceCycling) else{
            return
        }
        
        let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))
        
        let endDate = Calendar.current.date(byAdding: .day,value: 6, to: Date())
        
        let healthPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        
        let searchCollectionsQuery = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: healthPredicate,options: .cumulativeSum ,anchorDate: startDate!, intervalComponents: DateComponents(day: 1))
        
        // Initial Query Search
        searchCollectionsQuery.initialResultsHandler = {query,stats,err in
            if let stats = stats{
                DispatchQueue.main.async{
                    stats.enumerateStatistics(from: startDate!, to: endDate!) { stats, _ in
                        print("Distance: \(Int(stats.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0))")
                    }
                }
            }
            
        }
        
        searchCollectionsQuery.statisticsUpdateHandler = {query,stats,statisticsCollection,err in
            statisticsCollection?.enumerateStatistics(from: startDate!, to: endDate!, with: { stats, _ in
                print("Update Distance: \(Int(stats.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0))")
            })
        }
    }
    
    
    
    
    
    
}
