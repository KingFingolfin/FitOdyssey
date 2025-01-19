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
    
    func fetchWorkoutPlans(completion: @escaping ([WorkoutPlan]) -> Void) {
        let firestore = Firestore.firestore()
        firestore.collection("Plans")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching workout plans: \(error.localizedDescription)")
                    return
                }
                let plans = snapshot?.documents.compactMap { try? $0.data(as: WorkoutPlan.self) } ?? []
                completion(plans)
            }
    }
}


