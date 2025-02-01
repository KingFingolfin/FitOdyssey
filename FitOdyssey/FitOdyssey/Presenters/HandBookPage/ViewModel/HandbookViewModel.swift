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
        fetchMeals()
        fetchExercises()
        fetchWorkoutPlans()
    }
    
    func fetchMeals() {
        let firestore = Firestore.firestore()
        firestore.collection("Meals")
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching meals: \(error.localizedDescription)")
                    return
                }
                self?.meals = snapshot?.documents.compactMap { try? $0.data(as: Meal.self) } ?? []
            }
    }
    
    func fetchExercises() {
        let firestore = Firestore.firestore()
        firestore.collection("Exercises")
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching exercises: \(error.localizedDescription)")
                    return
                }
                self?.exercises = snapshot?.documents.compactMap { try? $0.data(as: Exercise.self) } ?? []
                print("🔥🔥🔥🔥🔥🔥exercisesFound🔥🔥🔥🔥🔥🔥🔥")
            }
    }
    
    func fetchWorkoutPlans() {
        let firestore = Firestore.firestore()

        firestore.collection("BookPlans").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching workout plans: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No workout plans found.")
                return
            }

            var workoutPlans: [WorkoutPlan] = []
            var allExerciseIds: Set<String> = []

            for document in documents {
                do {
                    var plan = try document.data(as: WorkoutPlan.self)
                    plan.id = document.documentID
                    workoutPlans.append(plan)
                    allExerciseIds.formUnion(plan.exerciseIds)
                } catch {
                    print("Error decoding workout plan: \(error)")
                }
            }

            if allExerciseIds.isEmpty {
                print("No exercise IDs found.")
                self?.workoutPlans = workoutPlans
                return
            }

            firestore.collection("Exercises")
                .whereField(FieldPath.documentID(), in: Array(allExerciseIds))
                .getDocuments { [weak self] snapshot, error in
                    if let error = error {
                        print("Error fetching exercises: \(error.localizedDescription)")
                        self?.workoutPlans = workoutPlans
                        return
                    }
                    var exerciseMap: [String: Exercise] = [:]
                    
                    for document in snapshot?.documents ?? [] {
                        do {
                            var exercise = try document.data(as: Exercise.self)
                            exercise.id = document.documentID
                            exerciseMap[exercise.id!] = exercise
                        } catch {
                            print("Error decoding exercise: \(error)")
                        }
                    }
                    for i in 0..<workoutPlans.count {
                        let exerciseIds = workoutPlans[i].exerciseIds
                        workoutPlans[i].exercises = exerciseIds.compactMap { exerciseMap[$0] }
                    }
                    self?.workoutPlans = workoutPlans
                }
        }
    }
}
