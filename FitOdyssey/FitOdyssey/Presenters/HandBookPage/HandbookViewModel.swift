//
//  HandbookViewModel.swift
//  FitOdyssey
//
//  Created by Giorgi on 17.01.25.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

final class HandbookViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var exercises: [Exercise] = []
    @Published var workoutPlans: [WorkoutPlan] = []
    
    init() {
        fetchMeals { [weak self] fetchedMeals in
            DispatchQueue.main.async {
                self?.meals = fetchedMeals
            }
        }
        fetchExercises { [weak self] fetchExercises in
            DispatchQueue.main.async {
                self?.exercises = fetchExercises
            }
        }
        fetchWorkoutPlans { [weak self] fetchPlans in
            DispatchQueue.main.async {
                self?.workoutPlans = fetchPlans
            }
        }
    }
    
    func fetchMeals(completion: @escaping ([Meal]) -> Void) {
        let firestore = Firestore.firestore()
        firestore.collection("Meals")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching meals: \(error.localizedDescription)")
                    return
                }
                self.meals = snapshot?.documents.compactMap { try? $0.data(as: Meal.self) } ?? []
                completion(self.meals)
            }
    }
    
    func fetchExercises(completion: @escaping ([Exercise]) -> Void) {
        let firestore = Firestore.firestore()
        firestore.collection("Exercises")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching exercises: \(error.localizedDescription)")
                    return
                }
                let exercises = snapshot?.documents.compactMap { try? $0.data(as: Exercise.self) } ?? []
                completion(exercises)
            }
    }
    
//    func fetchWorkoutPlans(completion: @escaping ([WorkoutPlan]) -> Void) {
//        let firestore = Firestore.firestore()
//        firestore.collection("Plans")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching workout plans: \(error.localizedDescription)")
//                    return
//                }
//                let plans = snapshot?.documents.compactMap { try? $0.data(as: WorkoutPlan.self) } ?? []
//                completion(plans)
//                
//                print("🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴")
//                print(plans)
//            }
//    }
    
    func fetchWorkoutPlans(completion: @escaping ([WorkoutPlan]) -> Void) {
        let firestore = Firestore.firestore()
        
        // Step 1: Fetch Plans
        firestore.collection("Plans").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching plans: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No plans found.")
                completion([])
                return
            }
            
            // Parse plans and collect all exercise IDs
            var workoutPlans: [WorkoutPlan] = []
            var allExerciseIds: Set<String> = []
            
            for document in documents {
                do {
                    let plan = try document.data(as: WorkoutPlan.self)
                    workoutPlans.append(plan)
                    allExerciseIds.formUnion(plan.exerciseIds)
                } catch {
                    print("Error decoding plan: \(error)")
                }
            }
            
            // Step 2: Check for exercise IDs
            if allExerciseIds.isEmpty {
                print("No exercise IDs found.")
                completion(workoutPlans) // Return plans without exercises
                return
            }
            
            // Step 3: Fetch Exercises
            firestore.collection("Exercises")
                .whereField(FieldPath.documentID(), in: Array(allExerciseIds))
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching exercises: \(error.localizedDescription)")
                        completion(workoutPlans)
                        return
                    }
                    
                    guard let exerciseDocs = snapshot?.documents else {
                        print("No exercises found.")
                        completion(workoutPlans)
                        return
                    }
                    
                    // Map exercises by ID
                    var exerciseMap: [String: Exercise] = [:]
                    for document in exerciseDocs {
                        do {
                            let exercise = try document.data(as: Exercise.self)
                            if let id = exercise.id {
                                exerciseMap[id] = exercise
                            }
                        } catch {
                            print("Error decoding exercise: \(error)")
                        }
                    }
                    
                    // Map exercises to workout plans
                    for i in 0..<workoutPlans.count {
                        let exerciseIds = workoutPlans[i].exerciseIds
                        workoutPlans[i].exercises = exerciseIds.compactMap { exerciseMap[$0] }
                    }
                    
                    // Return completed plans
                    completion(workoutPlans)
                }
        }
    }


    

}


