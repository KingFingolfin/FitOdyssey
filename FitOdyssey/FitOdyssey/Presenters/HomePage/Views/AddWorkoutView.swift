//
//  AddWorkoutView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//
import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var handbookViewModel: HandbookViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var workoutName = ""
    @State private var searchText = ""
    @State private var selectedExercises: Set<Exercise> = []
    
    var filteredExercises: [Exercise] {
        handbookViewModel.exercises.filter { exercise in
            searchText.isEmpty ||
            exercise.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            TextField("Workout Plan Name", text: $workoutName)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top, 20)
                .foregroundStyle(.white)
            
            SearchBar(text: $searchText)
            
            List {
                ForEach(filteredExercises) { exercise in
                    ExerciseRow(
                        exercise: exercise,
                        isSelected: selectedExercises.contains(exercise)
                    ) {
                        if selectedExercises.contains(exercise) {
                            selectedExercises.remove(exercise)
                        } else {
                            selectedExercises.insert(exercise)
                        }
                    }
                }.listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            
            
            SelectedExercisesView(selectedExercises: selectedExercises)
            
            SaveWorkoutButton(
                workoutName: workoutName,
                selectedExercises: selectedExercises,
                action: saveWorkout
            )
        }
        .background(.appTabbarBack)
        .navigationTitle("Create Workout Plan")
        .navigationBarItems(leading:
            Button("Cancel") { dismiss() }
        )
    }
    
    func saveWorkout() {
        guard !workoutName.isEmpty, !selectedExercises.isEmpty else { return }
        
        let exerciseIds = selectedExercises.compactMap { $0.id }
        profileViewModel.addWorkoutPlanToUser(name: workoutName, exercises: exerciseIds)
        dismiss()
    }
}
