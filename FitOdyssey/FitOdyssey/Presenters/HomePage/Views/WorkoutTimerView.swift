//
//  WorkoutTimerView.swift
//  FitOdyssey
//
//  Created by Giorgi on 23.01.25.
//

import SwiftUI

struct WorkoutTimerView: View {
    @State var plan: WorkoutPlan
    @StateObject private var viewModel = WorkoutTimerViewModel()
    
    @GestureState private var dragOffset = CGSize.zero
    @State private var timerPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)

    var body: some View {
        ZStack {
            Color.appBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(0..<plan.exercises.count, id: \.self) { exerciseIndex in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(plan.exercises[exerciseIndex].name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            ExerciseImageView(imageURL: plan.exercises[exerciseIndex].image)
                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .cornerRadius(10)
                                .padding(.bottom)
                            
                            VStack(spacing: 15) {
                                ForEach(0..<max(viewModel.exerciseSets.count > exerciseIndex ? viewModel.exerciseSets[exerciseIndex].count : 0, 0), id: \.self) { setIndex in
                                    
                                    HStack(alignment: .bottom,spacing: 20) {
                                        VStack {
                                            Text("Reps")
                                                .foregroundColor(.gray)
                                            TextField("Reps", text: Binding(
                                                get: {
                                                    viewModel.exerciseSets.indices.contains(exerciseIndex) &&
                                                    viewModel.exerciseSets[exerciseIndex].indices.contains(setIndex)
                                                    ? String(viewModel.exerciseSets[exerciseIndex][setIndex].reps)
                                                    : ""
                                                },
                                                set: { newValue in
                                                    if let intValue = Int(newValue) {
                                                        viewModel.updateExerciseSet(exerciseIndex: exerciseIndex, setIndex: setIndex, reps: intValue, weight: nil)
                                                    }
                                                }
                                            ))
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.numberPad)
                                            .frame(width: 100)
                                        }
                                        
                                        if plan.exercises[exerciseIndex].type == .repsAndWeight {
                                            VStack {
                                                Text("Weight")
                                                    .foregroundColor(.gray)
                                                TextField("Weight", text: Binding(
                                                    get: {
                                                        viewModel.exerciseSets.indices.contains(exerciseIndex) &&
                                                        viewModel.exerciseSets[exerciseIndex].indices.contains(setIndex) &&
                                                        viewModel.exerciseSets[exerciseIndex][setIndex].weight != nil
                                                        ? String(viewModel.exerciseSets[exerciseIndex][setIndex].weight!)
                                                        : ""
                                                    },
                                                    set: { newValue in
                                                        if let doubleValue = Double(newValue) {
                                                            viewModel.updateExerciseSet(exerciseIndex: exerciseIndex, setIndex: setIndex, reps: nil, weight: doubleValue)
                                                        }
                                                    }
                                                ))
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.decimalPad)
                                                .frame(width: 100)
                                            }
                                        }
                                        
                                        Button(action: {
                                            viewModel.currentTimerSet = (exerciseIndex, setIndex)
                                            viewModel.timeRemaining = 60
                                            viewModel.timerMode = .exercise
                                            viewModel.isTimerRunning = true
                                        }) {
                                            Image(systemName: "timer")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(viewModel.exerciseSets[exerciseIndex][setIndex].isCompleted ? Color.orange : Color.blue)
                                                .cornerRadius(10)
                                        }
                                    }
                                    .padding()
                                    .background(viewModel.exerciseSets[exerciseIndex][setIndex].isCompleted ? Color.orange.opacity(0.2) : Color.clear)
                                    .cornerRadius(10)
                                    
                                }
                                
                                Button(action: {
                                    viewModel.ensureExerciseSetsInitialized(for: exerciseIndex)
                                    viewModel.exerciseSets[exerciseIndex].append(
                                        WorkoutSet(
                                            reps: 10,
                                            weight: plan.exercises[exerciseIndex].type == .repsAndWeight ? 45.0 : nil
                                        )
                                    )
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add Set")
                                    }
                                    .foregroundColor(.green)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    }
                }
                .padding()
            }
            if viewModel.currentTimerSet != nil {
                VStack(spacing: 16) { 
                    Text(viewModel.timerMode == .exercise ? "Exercise" : "Recovery")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 24) {
                        Button(action: { viewModel.adjustTime(by: -15) }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                        
                        Text(viewModel.timeString(from: viewModel.timeRemaining))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Button(action: { viewModel.adjustTime(by: 15) }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                        }
                    }
                    
                    HStack(spacing: 32) {
                        Button(action: { viewModel.isTimerRunning.toggle() }) {
                            Image(systemName: viewModel.isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title)
                                .foregroundColor(viewModel.isTimerRunning ? .red : .green)
                        }
                        
                        Button(action: viewModel.skipTimer) {
                            Image(systemName: "forward.end.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.orange, lineWidth: 2)
                                .shadow(color: Color.orange.opacity(0.5), radius: 10, x: 0, y: 0)
                        )
                )
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 8)
                .position(timerPosition)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            withAnimation {
                                timerPosition.x += value.translation.width
                                timerPosition.y += value.translation.height
                            }
                        }
                )
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if viewModel.isTimerRunning && viewModel.timeRemaining > 0 {
                viewModel.timeRemaining -= 1
            } else if viewModel.timeRemaining == 0 {
                viewModel.handleTimerCompletion()
            }
        }
    }
}
