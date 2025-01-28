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
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                
                if selectedTab == .workouts {
                    List {
                        ForEach(profileViewModel.myWorkouts) { plan in
                            NavigationLink(destination: WorkoutTimerView(plan: plan)) {
                                WorkoutPlanRowView(plan: plan)
                            }.listRowBackground(Color.clear)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let plan = profileViewModel.myWorkouts[index]
                                profileViewModel.deleteWorkoutPlan(planId: plan.id ?? "")
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .padding(.top, 20)
                } else {
                    List {
                        ForEach(handbookViewModel.workoutPlans) { plan in
                            NavigationLink(destination: WorkoutTimerView(plan: plan)) {
                                WorkoutPlanRowView(plan: plan)
                            }.listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(.appBackground)
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(handbookViewModel: handbookViewModel, profileViewModel: profileViewModel)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}












