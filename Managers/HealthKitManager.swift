/**
    Made using the tutorial given at WWDC 20 HealthKit Demonstration
    URL: https://developer.apple.com/videos/play/wwdc2020/10664/
 */


import Foundation
import HealthKit

class HealthKitManager : ObservableObject{
    
    // MARK: Shared Object
    static let healthKit = HealthKitManager()
    
    
    // MARK: Attributes
    
    private let healthStore : HKHealthStore?
    
    private var totalWeeklyStepCount : Int = 0
    
    @Published private var userWeeklySteps : [Int] = []
    @Published private var userDistanceWalkingRunning: [Double] = []
    @Published private var userDistanceCycling: [Double] = []
    
    @Published private var userNutritionCarbohydrates : Double = 0.0
    @Published private var userNutritionProtein : Double = 0.0
    @Published private var userNutritionFat : Double = 0.0
    @Published private var dailyCaloricalIntake : Double = 0.0
    @Published private var dailyCaloriesBurnt : Double = 0.0
    
    private var quantityInfo : Set<HKObjectType> = Set([
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
        HKObjectType.quantityType(forIdentifier: .dietaryProtein)!
    ])
    
    // MARK: Functions
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            // Health Data is available
            healthStore = HKHealthStore()
            _Concurrency.Task{
                try await requestReadPermission(quantities: quantityInfo)
                self.getStepCountSample()
                self.getDistanceCycledSample()
                self.getWalkingRunningDistanceSample()
                self.getUserNutritionalCarbohydrateGrams()
                try await self.sendDataToWatch()
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
    
    private func getStepCountSample(){
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
    
    private func getWalkingRunningDistanceSample(){
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else{
            return
        }
        
        let endDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))
        
        let startDate = Calendar.current.date(byAdding: .day,value: -6, to: Date())
        
        let healthKitPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate,options: .strictStartDate)
        
        let searchQuery = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: healthKitPredicate,options: .cumulativeSum, anchorDate: startDate!, intervalComponents: DateComponents(day: 1))
        
        // Initial Query Call
        
        searchQuery.initialResultsHandler = {query,stats,err in
            if let stats = stats{
                DispatchQueue.main.async{
                    stats.enumerateStatistics(from: startDate! ,to: endDate!) { stats, _ in
                        DispatchQueue.main.async{
                            self.userDistanceWalkingRunning.append(Double(stats.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0.0))
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
                        self.userDistanceWalkingRunning.append(Double(stats.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0.0))
                    }
                })
            }
        }
        
        healthStore?.execute(searchQuery)
    }
    
    private func getDistanceCycledSample(){
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
                        self.userDistanceCycling.append(Double(stats.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0))
                    }
                }
            }
            
        }
        
        searchCollectionsQuery.statisticsUpdateHandler = {query,stats,statisticsCollection,err in
            statisticsCollection?.enumerateStatistics(from: startDate!, to: endDate!, with: { stats, _ in
                print("Update Distance: \(Int(stats.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0))")
            })
        }
        
        healthStore?.execute(searchCollectionsQuery)
    }
    
    private func getUserNutritionalCarbohydrateGrams(){
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .dietaryCarbohydrates) else{
            return
        }
        
        let endDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))
        
        let startDate = Calendar.current.date(byAdding: .day,value: -1, to: Date())
        
        let healthKitPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate,options: .strictStartDate)
        
        let searchQuery = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: healthKitPredicate,options: .cumulativeSum, anchorDate: startDate!, intervalComponents: DateComponents(day: 1))
        
        // Initial Query Call
        
        searchQuery.initialResultsHandler = {query,stats,err in
            if let stats = stats{
                DispatchQueue.main.async{
                    stats.enumerateStatistics(from: startDate! ,to: endDate!) { stats, _ in
                        self.userNutritionCarbohydrates = Double(stats.sumQuantity()?.doubleValue(for: .gram()) ?? 0.0)
                    }
                }
            }
        }
        
        // Backgorund Query Call For Updating Records
        searchQuery.statisticsUpdateHandler = {query,statistics,statisticsCollection,error in
            DispatchQueue.main.async{
                var sum = 0.0
                statisticsCollection?.enumerateStatistics(from: startDate!, to: endDate!, with: { stats, _ in
                    self.userNutritionCarbohydrates = Double(stats.sumQuantity()?.doubleValue(for: .gram()) ?? 0.0)
                })
            }
        }
        
        healthStore?.execute(searchQuery)
    }
    
    private func getUserNutrionalProteinSample(){
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .dietaryProtein) else{
            return
        }
        
        let endDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))
        
        let startDate = Calendar.current.date(byAdding: .day,value: -1, to: Date())
        
        let healthPredicate = HKQuery.predicateForSamples(withStart: startDate!, end: endDate!, options: .strictStartDate)
        
        let searchQuery = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: healthPredicate, anchorDate: startDate!, intervalComponents: DateComponents(day: 1))
        
        searchQuery.initialResultsHandler = {query,stats,err in
            if let stats = stats{
                stats.enumerateStatistics(from: startDate!, to: endDate!) { stats, _ in
                    DispatchQueue.main.async{
                        self.userNutritionProtein = Double(stats.sumQuantity()?.doubleValue(for: .gram()) ?? 0.0)
                    }
                }
            }
        }
        
        searchQuery.statisticsUpdateHandler = {query,stats,statisticsCollection,err in
            DispatchQueue.main.async{
                statisticsCollection?.enumerateStatistics(from: startDate!, to: endDate!, with: { stats, _ in
                    self.userNutritionProtein = Double(stats.sumQuantity()?.doubleValue(for: .gram()) ?? 0.0)
                })
            }
        }
        
        healthStore?.execute(searchQuery)
    }
    
    private func getUserNutritionalFatSample(){
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .dietaryProtein) else{
            return
        }
        
        let endDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date()))
        
        let startDate = Calendar.current.date(byAdding: .day,value: -1, to: Date())
        
        let healthPredicate = HKQuery.predicateForSamples(withStart: startDate!, end: endDate!, options: .strictStartDate)
        
        let searchQuery = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: healthPredicate, anchorDate: startDate!, intervalComponents: DateComponents(day: 1))
        
        searchQuery.initialResultsHandler = {query,stats,err in
            if let stats = stats{
                stats.enumerateStatistics(from: startDate!, to: endDate!) { stats, _ in
                    DispatchQueue.main.async{
                        self.userNutritionFat = Double(stats.sumQuantity()?.doubleValue(for: .gram()) ?? 0.0)
                    }
                }
            }
        }
        
        searchQuery.statisticsUpdateHandler = {query,stats,statisticsCollection,err in
            DispatchQueue.main.async{
                statisticsCollection?.enumerateStatistics(from: startDate!, to: endDate!, with: { stats, _ in
                    self.userNutritionFat = Double(stats.sumQuantity()?.doubleValue(for: .gram()) ?? 0.0)
                })
            }
        }
        
        healthStore?.execute(searchQuery)
    }
    
    func sumStepsInAWeek() -> Int{
        return self.userWeeklySteps.reduce(0, +)
    }
    
    func sumWalkingRunningDistance() -> Int{
        return Int(self.userDistanceWalkingRunning.reduce(0, +))
    }
    
    func sumCyclingDistance() -> Int{
        return Int(self.userDistanceCycling.reduce(0, +))
    }
    
    func getUserNutritionalCarbohydrate() -> Double{
        return self.userNutritionCarbohydrates
    }
    
    func getUserNutritionalProtein() -> Double{
        return self.userNutritionProtein
    }
    
    func getUserNutritionalFat() -> Double{
        return self.userNutritionFat
    }
    
    func sendDataToWatch(){
        let message = "CalIntake:\(self.dailyCaloricalIntake);CalBurn:\(self.dailyCaloriesBurnt);WalkRunDis:\(self.sumWalkingRunningDistance());CyclingDis:\(self.sumCyclingDistance())"
        BluetoothManager.bluetooth_manager.sendMessage(message: message, characteristic: .NutritionalInfoChar)
    }
    
}
