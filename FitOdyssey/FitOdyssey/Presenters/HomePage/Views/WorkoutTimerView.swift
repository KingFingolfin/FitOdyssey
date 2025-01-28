//
//  WorkoutTimerView.swift
//  FitOdyssey
//
//  Created by Giorgi on 23.01.25.
//
//



import SwiftUI
import FirebaseStorage

struct WorkoutTimerView: View {
    @State var plan: WorkoutPlan
    
    @StateObject private var soundViewModel = SoundViewModel()
    @State private var exerciseSets: [[WorkoutSet]] = []
    @State private var currentTimerSet: (exerciseIndex: Int, setIndex: Int)? = nil
    @State private var timeRemaining: Int = 90
    @State private var isTimerRunning = false
    @State private var timerMode: TimerMode = .exercise
    
    @GestureState private var dragOffset = CGSize.zero
    @State private var timerPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    enum TimerMode {
        case exercise
        case recovery
    }
    
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
                                ForEach(0..<max(exerciseSets.count > exerciseIndex ? exerciseSets[exerciseIndex].count : 0, 0), id: \.self) { setIndex in
                                    
                                    HStack(alignment: .bottom,spacing: 20) {
                                        VStack {
                                            Text("Reps")
                                                .foregroundColor(.gray)
                                            TextField("Reps", text: Binding(
                                                get: {
                                                    exerciseSets.indices.contains(exerciseIndex) &&
                                                    exerciseSets[exerciseIndex].indices.contains(setIndex)
                                                    ? String(exerciseSets[exerciseIndex][setIndex].reps)
                                                    : ""
                                                },
                                                set: { newValue in
                                                    if let intValue = Int(newValue) {
                                                        if exerciseSets.count <= exerciseIndex {
                                                            exerciseSets.append([])
                                                        }
                                                        if exerciseSets[exerciseIndex].count <= setIndex {
                                                            exerciseSets[exerciseIndex].append(WorkoutSet(reps: intValue, weight: nil))
                                                        } else {
                                                            exerciseSets[exerciseIndex][setIndex].reps = intValue
                                                        }
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
                                                        exerciseSets.indices.contains(exerciseIndex) &&
                                                        exerciseSets[exerciseIndex].indices.contains(setIndex) &&
                                                        exerciseSets[exerciseIndex][setIndex].weight != nil
                                                        ? String(exerciseSets[exerciseIndex][setIndex].weight!)
                                                        : ""
                                                    },
                                                    set: { newValue in
                                                        if let doubleValue = Double(newValue) {
                                                            if exerciseSets.count <= exerciseIndex {
                                                                exerciseSets.append([])
                                                            }
                                                            if exerciseSets[exerciseIndex].count <= setIndex {
                                                                exerciseSets[exerciseIndex].append(WorkoutSet(reps: 10, weight: doubleValue))
                                                            } else {
                                                                exerciseSets[exerciseIndex][setIndex].weight = doubleValue
                                                            }
                                                        }
                                                    }
                                                ))
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.decimalPad)
                                                .frame(width: 100)
                                            }
                                        }
                                        
                                        Button(action: {
                                            currentTimerSet = (exerciseIndex, setIndex)
                                            timeRemaining = 60
                                            timerMode = .exercise
                                            isTimerRunning = true
                                        }) {
                                            Image(systemName: "timer")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(exerciseSets[exerciseIndex][setIndex].isCompleted ? Color.orange : Color.blue)
                                                .cornerRadius(10)
                                        }
                                    }
                                    .padding()
                                    .background(exerciseSets[exerciseIndex][setIndex].isCompleted ? Color.orange.opacity(0.2) : Color.clear)
                                    .cornerRadius(10)
                                    
                                }
                                
                                Button(action: {
                                    ensureExerciseSetsInitialized(for: exerciseIndex)
                                    exerciseSets[exerciseIndex].append(
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
            
    if currentTimerSet != nil {
                VStack {
                    HStack {
                        Button(action: { adjustTime(by: -15) }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                        
                        Text(timeString(from: timeRemaining))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Button(action: { adjustTime(by: 15) }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                        }
                    }
                    
                    HStack {
                        Button(action: { isTimerRunning.toggle() }) {
                            Image(systemName: isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title)
                                .foregroundColor(isTimerRunning ? .red : .green)
                        }
                        
                        Button(action: skipTimer) {
                            Image(systemName: "forward.end.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        
                        Text(timerMode == .exercise ? "Exercise" : "Recovery")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(50)
                .shadow(radius: 10)
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
            if isTimerRunning && timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 {
                handleTimerCompletion()
            }
        }
    }
    
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }

    private func adjustTime(by seconds: Int) {
        timeRemaining = max(0, min(timeRemaining + seconds, 600))
    }

    private func skipTimer() {
        if timerMode == .exercise {
            timeRemaining = 90
            timerMode = .recovery
            isTimerRunning = true
        } else {
            currentTimerSet = nil
            isTimerRunning = false
            timerMode = .exercise
        }
    }

    private func handleTimerCompletion() {
        if timerMode == .exercise {
            soundViewModel.playSound(named: "timer_end")
            
            if let currentTimerSet = currentTimerSet {
                exerciseSets[currentTimerSet.exerciseIndex][currentTimerSet.setIndex].isCompleted = true
            }
            timeRemaining = 90
            timerMode = .recovery
            isTimerRunning = true
        } else {
            
            soundViewModel.playSound(named: "timer_end")
            
            currentTimerSet = nil
            isTimerRunning = false
            timerMode = .exercise
        }
    }


    private func ensureExerciseSetsInitialized(for exerciseIndex: Int) {
        while exerciseSets.count <= exerciseIndex {
            exerciseSets.append([])
        }
    }
    
}

