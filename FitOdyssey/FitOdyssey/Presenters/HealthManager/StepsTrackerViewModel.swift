//
//  StepsTrackerViewModel.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//


import SwiftUI
import HealthKit

class StepsTrackerViewModel: ObservableObject {
    @Published var stepCount: Double = 0
    @Published var isHealthDataAvailable: Bool = false
    @Published var goal: Double = 10000 // Default goal: 10,000 steps

    private let healthStore = HKHealthStore()

    init() {
        requestHealthDataAccess()
        fetchStepsData()
    }

    // Request permission to access HealthKit data
    func requestHealthDataAccess() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        if HKHealthStore.isHealthDataAvailable() {
            let typesToShare: Set = [stepType]
            let typesToRead: Set = [stepType]

            healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
                if success {
                    self.isHealthDataAvailable = true
                    self.fetchStepsData() // Fetch data after authorization
                } else {
                    self.isHealthDataAvailable = false
                    print("Health data authorization failed: \(String(describing: error))")
                }
            }
        }
    }

    // Fetch the step count data from HealthKit
    func fetchStepsData() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, error == nil else {
                print("Error fetching steps: \(String(describing: error))")
                return
            }

            if let sum = result.sumQuantity() {
                let steps = sum.doubleValue(for: HKUnit.count())
                DispatchQueue.main.async {
                    self.stepCount = steps
                }
            }
        }

        healthStore.execute(query)
    }

    // Reset step count (for new day)
    func resetStepsData() {
        stepCount = 0
    }
}


import SwiftUI

struct StepsTrackerView: View {
    @StateObject private var viewModel = StepsTrackerViewModel()

    var body: some View {
        VStack {
            if viewModel.isHealthDataAvailable {
                // Circular Progress View
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.stepCount / viewModel.goal)) // Assuming goal is 10,000 steps
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: -90)) // Rotate to start from top
                    .frame(width: 200, height: 200)
                    .overlay(
                        Text("\(Int(viewModel.stepCount))")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    )
                    .padding()

                // Step Goal Display
                Text("Step Goal: \(Int(viewModel.goal))")
                    .font(.headline)
                    .padding()

            } else {
                Text("Health Data Not Available")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear {
            // Re-fetch data when view appears
            viewModel.fetchStepsData()
        }
    }
}
