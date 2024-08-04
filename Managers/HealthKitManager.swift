/**
    Made using the tutorial given at WWDC 20 HealthKit Demonstration
    URL: https://developer.apple.com/videos/play/wwdc2020/10664/
 */


import Foundation
import HealthKit

class HealthKitManager : ObservableObject{
    
    static let healthKit = HealthKitManager()
    
    private let healthStore : HKHealthStore?
    
    private var totalWeeklyStepCount : Int = 0
    @Published private var userWeeklySteps : [Int] = []
    @Published var userDistanceWalkingRunning: [Double] = []
    
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
            _Concurrency.Task{
                try await requestReadPermission(quantities: quantityInfo)
                self.getStepCountSample()
                self.getWalkingRunningDistanceSample()
            }
        }else{
            // No health data is available so we need to make the store nil. Essentially making this manager useless
            healthStore = nil
        }
    }
    
    func requestReadPermission(quantities: Set<HKObjectType>){
        self.healthStore?.requestAuthorization(toShare: nil, read: quantities, completion: { res, err in
            if res{
                
            }else{
                
            }
        })
    }
    
    func getStepCountSample(){
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
                    stats.enumerateStatistics(from: startDate! ,to: endDate!) { stats, _ in
                        DispatchQueue.main.async{
                            self.userWeeklySteps.append(Int(stats.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0))
                        }
                    }
                }
            }
        }
        
        // Backgorund Query Call For Updating Records
        searchQuery.statisticsUpdateHandler = {query,statistics,statisticsCollection,error in
            DispatchQueue.main.async{
                statisticsCollection?.enumerateStatistics(from: startDate!, to: endDate!, with: { stats, _ in
                    DispatchQueue.main.async{
                        self.userWeeklySteps.append(Int(stats.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0))
                    }
                })
            }
        }
        
        healthStore?.execute(searchQuery)
    }
    
    func getWalkingRunningDistanceSample(){
        print("Getting Walking Running Distance")
        
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else{
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        
        let endDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))
        
        let runningWalkingPred = HKQuery.predicateForSamples(withStart: startDate, end: endDate,options: .strictStartDate)
        
        let searchCollectionsQuery = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: runningWalkingPred, anchorDate: startDate!, intervalComponents: DateComponents(day: 1))
        
        searchCollectionsQuery.initialResultsHandler = {query,stats,err in
            if let res = stats{
                DispatchQueue.main.async{
                    res.enumerateStatistics(from: startDate!, to: endDate!) { statistics, _ in
                        let distance = statistics.sumQuantity()?.doubleValue(for: HKUnit.count())
                        print("Initial Distance: \(distance)")
                        self.userDistanceWalkingRunning.append(distance ?? 0.0)
                    }
                }
            }
        }
        
        searchCollectionsQuery.statisticsUpdateHandler = {query,stats,statsCollection,err in
            statsCollection?.enumerateStatistics(from: startDate!, to: endDate!, with: { stats, _ in
                DispatchQueue.main.async{
                    print("Update: \(Int(stats.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0))")
                }
            })
        }
        
        healthStore?.execute(searchCollectionsQuery)
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
    
    func sumStepsInAWeek() -> Int{
        return self.userWeeklySteps.reduce(0, +)
    }
    
    func sumWalkingRunningDistance() -> Int{
        return Int(self.userDistanceWalkingRunning.reduce(0, +))
    }
    
    
    
    
    
    
}
