//
//  Meal.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//
import FirebaseFirestore


struct Meal: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String = ""
    var image: String = ""
    var recipe: String = ""
}
