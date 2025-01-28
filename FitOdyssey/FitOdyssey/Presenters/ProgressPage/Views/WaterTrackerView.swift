//
//  WaterTrackerView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//


import SwiftUI

struct WaterTrackerView: View {
    @State private var currentWater: Double = 0
    @State private var goal: Double = 3
    @State private var waterHeight: CGFloat = 0
    @State private var customGoal: String = "3"
    
    let maxWater: Double = 3
    
    // Timer to reset the water at midnight (simulate with a 1-second timer for demo)
    @State private var resetTimer: Timer?
    
    var body: some View {
        VStack {
            // Custom Daily Goal Input
            HStack {
                Text("Set Daily Goal (L):")
                    .font(.headline)
                TextField("Goal", text: $customGoal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .onSubmit {
                        if let newGoal = Double(customGoal) {
                            goal = newGoal
                        }
                    }
                    .frame(width: 80)
            }
            .padding()
            
            // Glass Background with Realistic Look
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
                    .shadow(radius: 10)
                    .frame(width: 200, height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    )
                
                // Water Fill
                RoundedRectangle(cornerRadius: 30)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 200, height: waterHeight)
                    .cornerRadius(20)
                    .animation(.easeInOut(duration: 0.5), value: waterHeight)
                    .position(x: 150, y: 300 - (waterHeight / 2))
            }
            
            // Display current water and goal
            HStack {
                Text("Goal: \(Int(goal))L")
                    .font(.headline)
                Spacer()
                Text("Water: \(Int(currentWater))L")
                    .font(.headline)
            }
            .padding()

            // Controls: + and -
            HStack {
                Button(action: {
                    if currentWater > 0 {
                        currentWater -= 1
                        waterHeight = CGFloat(currentWater / goal) * 300
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding()
                
                Button(action: {
                    if currentWater < goal {
                        currentWater += 1
                        waterHeight = CGFloat(currentWater / goal) * 300
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding()
            }
        }
        .onAppear {
            setupDailyReset()
        }
        .onChange(of: currentWater) { newValue in
            waterHeight = CGFloat(newValue / goal) * 300
        }
    }
    
    // Function to reset water daily
    func setupDailyReset() {
        let calendar = Calendar.current
        let currentDate = Date()
        let nextDay = calendar.nextDate(after: currentDate, matching: .init(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        
        // Schedule the reset for the next midnight
        let timeInterval = nextDay.timeIntervalSince(currentDate)
        
        resetTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            // Reset the water and goal for the new day
            currentWater = 0
            waterHeight = 0
        }
    }
}

