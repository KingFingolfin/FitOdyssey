//
//  SaveWorkoutButton.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//
import SwiftUI

struct SaveWorkoutButton: View {
    let workoutName: String
    let selectedExercises: Set<Exercise>
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Save Workout Plan")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    workoutName.isEmpty || selectedExercises.isEmpty
                        ? Color.gray
                        : Color.appOrange
                )
                .cornerRadius(10)
        }
        .disabled(workoutName.isEmpty || selectedExercises.isEmpty)
        .padding()
    }
}
