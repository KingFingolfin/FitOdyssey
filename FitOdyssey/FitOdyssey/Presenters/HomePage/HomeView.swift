//
//  LoginView.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct WorkoutView: View {
    @StateObject private var handbookViewModel = HandbookViewModel()
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var selectedTab: WorkoutTab = .workouts
    @State private var showingAddWorkout = false
    
    enum WorkoutTab {
        case workouts
        case plans
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    
                    Text("CREATE \(profileViewModel.profile.name)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    if selectedTab == .workouts {
                        Button(action: {
                            showingAddWorkout = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                
                HStack(spacing: 0) {
                    TabButton(text: "WORKOUTS", isSelected: selectedTab == .workouts) {
                        selectedTab = .workouts
                    }
                    TabButton(text: "PLANS", isSelected: selectedTab == .plans) {
                        selectedTab = .plans
                    }
                }
                
                HStack {
                    Text("DATE")
                        .foregroundColor(.white)
                        .opacity(0.7)
                    Spacer()
                    Button(action: {
                       
                        
                    }) {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease")
                            Text("SORT BY")
                        }
                        .foregroundColor(.white)
                        .opacity(0.7)
                    }
                }
                .padding()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if selectedTab == .workouts {
                            ForEach(profileViewModel.myWorkouts, id: \.name) { plan in
                                MyPlanCard(
                                        plan: plan,
                                        onDelete: {
                                            profileViewModel.deleteWorkoutPlan(planId: plan.id ?? "")
                                        }
                                    )
                                
                            }
                        } else {
                            ForEach(handbookViewModel.workoutPlans, id: \.name) { plan in
                                PlanCard(plan: plan)
                            }
                        }
                    }
                    .padding()
                }
                
            }
            .background(.appBackground)
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(handbookViewModel: handbookViewModel, profileViewModel: profileViewModel)
            }
        }.navigationBarBackButtonHidden(true)
    }
}


struct PlanCard: View {
    let plan: WorkoutPlan

    var body: some View {
        NavigationLink(destination: WorkoutTimerView(plan: plan)) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(plan.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    if !plan.exercises.isEmpty {
                        Text(plan.exercises.map { $0.name }.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    } else {
                        Text("No exercises")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
}



struct MyPlanCard: View {
    let plan: WorkoutPlan
    let onDelete: () -> Void
    @State private var offset: CGFloat = 0
    @State private var showDelete: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            if showDelete {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            onDelete()
                        }
                    }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(maxWidth: 60, maxHeight: .infinity)
                    }
                    .background(Color.red)
                }
            }

            NavigationLink(destination: WorkoutTimerView(plan: plan)) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(plan.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        if !plan.exercises.isEmpty {
                            Text(plan.exercises.map { $0.name }.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        } else {
                            Text("No exercises")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            }
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            self.offset = gesture.translation.width
                            self.showDelete = true
                        }
                    }
                    .onEnded { gesture in
                        withAnimation {
                            if gesture.translation.width < -50 {
                                self.offset = -60
                                self.showDelete = true
                            } else {
                                self.offset = 0
                                self.showDelete = false
                            }
                        }
                    }
            )
        }
    }
}

struct TabButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(text)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(isSelected ? .white : .clear)
            }
        }
    }
}


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
        NavigationView {
            VStack(spacing: 15) {
                TextField("Workout Plan Name", text: $workoutName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
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
                    }
                }
                .listStyle(PlainListStyle())
                
                SelectedExercisesView(selectedExercises: selectedExercises)
                
                SaveWorkoutButton(
                    workoutName: workoutName,
                    selectedExercises: selectedExercises,
                    action: saveWorkout
                )
            }
            .navigationTitle("Create Workout Plan")
            .navigationBarItems(leading:
                Button("Cancel") { dismiss() }
            )
        }
    }
    
    func saveWorkout() {
        guard !workoutName.isEmpty, !selectedExercises.isEmpty else { return }
        
        let exerciseIds = selectedExercises.compactMap { $0.id }
        profileViewModel.addWorkoutPlanToUser(name: workoutName, exercises: exerciseIds)
        dismiss()
    }
}

import FirebaseStorage
struct ExerciseRow: View {
    let exercise: Exercise
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var exerciseImage: UIImage? = nil
    
    var body: some View {
        HStack {
            if let image = exerciseImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .overlay(ProgressView().padding(), alignment: .center)
                    .onAppear {
                        loadImage(from: exercise.image)
                    }
            }
            
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
            }
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .green : .gray)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let storageRef = Storage.storage().reference(forURL: url.absoluteString)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.exerciseImage = image
                }
            }
        }
    }
}

struct SelectedExercisesView: View {
    let selectedExercises: Set<Exercise>
    
    var body: some View {
        Group {
            if !selectedExercises.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(selectedExercises)) { exercise in
                            Text(exercise.name)
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

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
                        : Color.blue
                )
                .cornerRadius(10)
        }
        .disabled(workoutName.isEmpty || selectedExercises.isEmpty)
        .padding()
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search Exercises", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
