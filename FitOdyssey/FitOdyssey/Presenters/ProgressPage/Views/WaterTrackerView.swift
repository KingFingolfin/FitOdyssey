//
//  WaterTrackerView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//


import SwiftUI

struct WaterTrackerView: View {
    @State private var currentWater: Double = UserDefaults.standard.double(forKey: "currentWater")
    @State private var goal: Double = 3
    @State private var waterHeight: CGFloat = 0
    @State private var customGoal: String = "3"

    let maxWater: Double = 3
    @State private var resetTimer: Timer?

    var body: some View {
        HStack {
            Button(action: {
                if currentWater > 0 {
                    currentWater -= 1
                    updateWaterHeight()
                    saveWaterData()
                }
            }) {
                Image(systemName: "arrow.down.circle")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.blue)
            }
            .padding(.leading, 20)

            VStack {
                HStack {
                    Text("Goal:")
                        .font(.headline)
                        .foregroundStyle(.white)

                    TextField("Goal", text: $customGoal)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .foregroundStyle(.white)
                        .onSubmit {
                            if let newGoal = Double(customGoal) {
                                goal = newGoal
                            }
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding()

                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.clear)
                        .frame(width: 200, height: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        )

                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 200, height: waterHeight)
                        .cornerRadius(20)
                        .animation(.easeInOut(duration: 0.5), value: waterHeight)
                        .position(x: 100, y: 328 - (waterHeight / 2))
                }

                HStack {
                    Text("Goal: \(Int(goal))L")
                        .font(.headline)
                        .foregroundStyle(.appOrange)
                        .frame(width: 100)
                    Spacer()
                    Text("Water: \(Int(currentWater))L")
                        .font(.headline)
                        .foregroundStyle(.appOrange)
                        .frame(width: 100)
                }
                .padding()
            }

            Button(action: {
                if currentWater < goal {
                    currentWater += 1
                    updateWaterHeight()
                    saveWaterData()
                }
            }) {
                Image(systemName: "arrow.up.circle")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.blue)
            }
            .padding(.trailing, 20)
        }
        .onAppear {
            checkForNewDay()
            updateWaterHeight()
        }
        .onChange(of: currentWater) { _ in
            updateWaterHeight()
            saveWaterData()
        }
    }

    func updateWaterHeight() {
        waterHeight = CGFloat(currentWater / goal) * 300
    }

    func saveWaterData() {
        UserDefaults.standard.set(currentWater, forKey: "currentWater")
        UserDefaults.standard.set(Date(), forKey: "lastSavedDate")
    }

    func checkForNewDay() {
        let calendar = Calendar.current
        if let lastSavedDate = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date {
            if !calendar.isDate(lastSavedDate, inSameDayAs: Date()) {
                currentWater = 0
                saveWaterData()
            }
        } else {
            saveWaterData()
        }
    }
}


