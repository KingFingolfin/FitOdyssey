//
//  UserModel.swift
//  Wazaaaaaaaap
//
//  Created by Cotne Chubinidze on 21.12.24.
//
import FirebaseFirestore
import FirebaseAuth

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String
    let email: String
    var name: String
    var age: Int
    var weight: String = ""
    var height: Double
    var gender: String = ""
    var ImageUrl: String = ""
    var before_image: String = ""
    var after_image: String = ""
    var measurements: [Measurements] = []
    var workoutPlans: [WorkoutPlan] = []
}

struct Meal: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
    var image: String = ""
    var recipe: String = ""
}

struct Measurements: Codable {
    var date: Date
    var biceps: Double = 0
    var chest: Double = 0
    var waist: Double = 0
    var shoulders: Double = 0
}

struct Exercise: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
    var image: String = ""
    var instructions: String = ""
    var type: ExerciseType = ExerciseType.repsAndWeight
}

enum ExerciseType: String, Codable {
    case repsAndWeight
    case repsOnly
}

struct WorkoutPlan: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
    var exercises: [Exercise] = []
}

