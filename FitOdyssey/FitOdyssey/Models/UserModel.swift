//
//  Meal.swift
//  FitOdyssey
//
//  Created by Giorgi on 17.01.25.
//
import FirebaseFirestore
import FirebaseAuth

struct User: Codable, Identifiable {
    var id: String?
    let uid: String
    let email: String
    var name: String
    var age: String = ""
    var height: String = ""
    var gender: String = ""
    var ImageUrl: String = ""
    var before_image: String = ""
    var after_image: String = ""
    var measurements: [Measurements] = []
    var workoutPlans: [String] = []
}

struct Measurements: Codable {
    var date: Date
    var biceps: Double = 0
    var chest: Double = 0
    var waist: Double = 0
    var shoulders: Double = 0
    var weight: Double = 0
}

struct WorkoutPlan: Codable, Identifiable {
    var id: String?
    var name: String = ""
    var exerciseIds: [String] = []
    var exercises: [Exercise] = []

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case exerciseIds
    }
}



