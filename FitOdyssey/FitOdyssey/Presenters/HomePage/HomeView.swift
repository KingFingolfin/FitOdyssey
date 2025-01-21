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
                                PlanCard(plan: plan)
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
                AddWorkoutView(profileViewModel: profileViewModel)
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct WorkoutCard: View {
    let name: String
    let exerciseCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(name.uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("\(exerciseCount) EXERCISE\(exerciseCount != 1 ? "S" : "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                
                
                
            }) {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

struct PlanCard: View {
    let plan: WorkoutPlan

    var body: some View {
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


struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var workoutName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Details")) {
                    TextField("Workout Name", text: $workoutName)
                    
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    
                    guard !workoutName.isEmpty else { return }

                    profileViewModel.addWorkoutPlanToUser(name: workoutName, exercises: ["Wt5WBIb9MRLipTtkHcK9","Wt5WBIb9MRLipTtkHcK9","Wt5WBIb9MRLipTtkHcK9","Wt5WBIb9MRLipTtkHcK9"])
                    
                    dismiss()
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
