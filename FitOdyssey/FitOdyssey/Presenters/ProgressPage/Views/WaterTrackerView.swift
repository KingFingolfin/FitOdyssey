//
//  WaterTrackerView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//



import SwiftUI
import WidgetKit

struct WaterTrackerView: View {
    @State private var currentWater: Double = UserDefaults(suiteName: "group.com.example.FitOdyssey")?.double(forKey: "currentWater") ?? 0
    @State private var goal: Double = UserDefaults(suiteName: "group.com.example.FitOdyssey")?.double(forKey: "goal") ?? 3
    @State private var waterHeight: CGFloat = 0
    @State private var customGoal: String = "3"
    @State private var isEditing: Bool = false
    
    let containerHeight: CGFloat = 300
    
    let waterGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.0, green: 0.7, blue: 0.9),
            Color(red: 0.0, green: 0.4, blue: 0.9)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                if currentWater > 0 {
                    currentWater -= 1
                    updateWaterHeight()
                    saveWaterData()
                }
            }) {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "minus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 5, y: 2)
            }
            
            VStack {
                            HStack {
                                Text("Daily Goal:")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                TextField("Goal", text: $customGoal) { isEditing in
                                    self.isEditing = isEditing
                                }
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 60)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .onSubmit {
                                    if let newGoal = Double(customGoal), newGoal > 0 {
                                        if newGoal >= currentWater { // Restriction added
                                            goal = newGoal
                                            saveWaterData()
                                            updateWaterHeight()
                                        } else {
                                            // Reset the text field to the previous valid goal value
                                            customGoal = String(format: "%.1f", goal)
                                        }
                                    }
                                }
                                
                                Text("L")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(.top, 20)
                            
                            ZStack(alignment: .bottom) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                                    .frame(width: 200, height: containerHeight)
                                
                                Rectangle()
                                    .fill(waterGradient)
                                    .frame(width: 200, height: min(waterHeight, containerHeight))
                                    .overlay(
                                        WaveShape(progress: min(Double(currentWater / goal), 1.0))
                                            .fill(Color.white.opacity(0.1))
                                            .frame(height: 10)
                                            .offset(y: -5)
                                    )
                                    .overlay(
                                        BubblesView()
                                    )
                                    .animation(.easeInOut(duration: 0.5), value: waterHeight)
                                
                                Text("\(String(format: "%.1f", currentWater))L")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                                    .offset(y: -160)
                            }
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, y: 5)
                            .padding(.vertical, 40)
                        }
                        
                        Button(action: {
                            if currentWater < goal {
                                currentWater += 1
                                updateWaterHeight()
                                saveWaterData()
                            }
                        }) {
                            Circle()
                                .fill(waterGradient)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: Color.blue.opacity(0.3), radius: 5, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        customGoal = String(format: "%.1f", goal)
                        checkForNewDay()
                        updateWaterHeight()
                    }
                }

                func updateWaterHeight() {
                    let ratio = min(currentWater / goal, 1.0)
                    waterHeight = CGFloat(ratio) * containerHeight
                }

                func saveWaterData() {
                    let defaults = UserDefaults(suiteName: "group.com.example.FitOdyssey")
                    defaults?.set(currentWater, forKey: "currentWater")
                    defaults?.set(goal, forKey: "goal")
                    defaults?.set(Date(), forKey: "lastSavedDate")
                    reloadWidget()
                }

                func checkForNewDay() {
                    let calendar = Calendar.current
                    let defaults = UserDefaults(suiteName: "group.com.example.FitOdyssey")
                    if let lastSavedDate = defaults?.object(forKey: "lastSavedDate") as? Date {
                        if !calendar.isDate(lastSavedDate, inSameDayAs: Date()) {
                            currentWater = 0
                            saveWaterData()
                        }
                    } else {
                        saveWaterData()
                    }
                }
            }

struct WaveShape: Shape {
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let progressHeight = rect.height * CGFloat(progress)
        let width = rect.width
        
        path.move(to: CGPoint(x: 0, y: progressHeight))
        
        for x in stride(from: 0, to: width, by: 1) {
            let relativeX = x / 50
            let y = sin(relativeX) * 5
            path.addLine(to: CGPoint(x: x, y: progressHeight + y))
        }
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct BubblesView: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<8) { index in
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.1...0.3)))
                    .frame(width: CGFloat.random(in: 4...8), height: CGFloat.random(in: 4...8))
                    .offset(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height)
                    )
                    .animation(
                        Animation
                            .linear(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...2)),
                        value: UUID()
                    )
            }
        }
    }
}

func reloadWidget() {
    WidgetCenter.shared.reloadAllTimelines()
}
