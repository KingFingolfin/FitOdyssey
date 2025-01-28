//
//  WorkoutTimerViewModel.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI
import FirebaseStorage

class WorkoutTimerViewModel: ObservableObject {
    @Published var exerciseSets: [[WorkoutSet]] = []
    @Published var currentTimerSet: (exerciseIndex: Int, setIndex: Int)? = nil
    @Published var timeRemaining: Int = 90
    @Published var isTimerRunning = false
    @Published var timerMode: TimerMode = .exercise
    
    private var soundViewModel = SoundViewModel()
    
    enum TimerMode {
        case exercise
        case recovery
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }

    func adjustTime(by seconds: Int) {
        timeRemaining = max(0, min(timeRemaining + seconds, 600))
    }

    func skipTimer() {
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

    func handleTimerCompletion() {
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

    func ensureExerciseSetsInitialized(for exerciseIndex: Int) {
        while exerciseSets.count <= exerciseIndex {
            exerciseSets.append([])
        }
    }

    func updateExerciseSet(exerciseIndex: Int, setIndex: Int, reps: Int?, weight: Double?) {
        if reps != nil {
            exerciseSets[exerciseIndex][setIndex].reps = reps!
        }
        if weight != nil {
            exerciseSets[exerciseIndex][setIndex].weight = weight
        }
    }
}
