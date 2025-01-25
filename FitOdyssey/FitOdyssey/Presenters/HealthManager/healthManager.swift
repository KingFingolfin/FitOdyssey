//
//  healthManager.swift
//  FitOdyssey
//
//  Created by Giorgi on 19.01.25.
//

//import SwiftUI
//import HealthKit
//
//class StepCountViewModel: ObservableObject {
//    private var healthStore = HKHealthStore()
//    @Published var stepCount: Int = 0
//
//    init() {
//        requestAuthorization()
//    }
//
//    func requestAuthorization() {
//        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//
//        healthStore.requestAuthorization(toShare: nil, read: [stepType]) { success, error in
//            if success {
//                self.fetchSteps()
//            } else {
//                print("Authorization failed: \(String(describing: error))")
//            }
//        }
//    }
//
//    func fetchSteps() {
//        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        let now = Date()
//        let startOfDay = Calendar.current.startOfDay(for: now)
//
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//
//        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
//            guard let result = result, let sum = result.sumQuantity() else {
//                print("Failed to fetch steps: \(String(describing: error))")
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.stepCount = Int(sum.doubleValue(for: HKUnit.count()))
//            }
//        }
//
//        healthStore.execute(query)
//    }
//}
