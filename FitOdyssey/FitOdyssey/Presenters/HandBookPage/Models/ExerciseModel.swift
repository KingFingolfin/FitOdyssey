//
//  ExerciseModel.swift
//  FitOdyssey
//
//  Created by Giorgi on 17.01.25.
//
import FirebaseFirestore

struct Exercise: Codable, Identifiable, Hashable{
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
