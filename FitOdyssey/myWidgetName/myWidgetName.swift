//
//  myWidgetName.swift
//  myWidgetName
//
//  Created by Giorgi on 31.01.25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), currentWater: 0, goal: 3)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = loadData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = loadData()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func loadData() -> SimpleEntry {
        let defaults = UserDefaults(suiteName: "group.com.example.FitOdyssey")
        var currentWater = defaults?.double(forKey: "currentWater") ?? 0
        var goal = defaults?.double(forKey: "goal") ?? 3

        if currentWater == 0 || goal == 0 {
            currentWater = 0
            goal = 3
            defaults?.set(currentWater, forKey: "currentWater")
            defaults?.set(goal, forKey: "goal")
        }

        currentWater = max(0, currentWater)
        goal = max(0.1, goal)

        return SimpleEntry(date: Date(), currentWater: currentWater, goal: goal)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let currentWater: Double
    let goal: Double
}

struct WaterWidgetView: View {
    var entry: SimpleEntry
    
    let waterGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.0, green: 0.7, blue: 0.9),
            Color(red: 0.0, green: 0.4, blue: 0.9)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.1, green: 0.1, blue: 0.2),
            Color(red: 0.05, green: 0.05, blue: 0.1)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            Rectangle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    
                    Rectangle()
                        .fill(waterGradient)
                        .frame(
                            height: max(0, CGFloat(entry.currentWater / max(entry.goal, 0.1)) * geometry.size.height)
                        )
                        .overlay(
                            WaveShape(progress: Double(entry.currentWater / entry.goal))
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 10)
                                .offset(y: -5)
                        )
                        .overlay(
                            BubblesView()
                        )
                }
                .shadow(color: Color.blue.opacity(0.3), radius: 10, y: 5)
                
                VStack(spacing: 2) {
                    Text("\(Int(entry.currentWater))L")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("of \(Int(entry.goal))L")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.7))
                }
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
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

struct myWidgetName: Widget {
    let kind: String = "myWidgetName"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WaterWidgetView(entry: entry).ignoresSafeArea()
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WaterWidgetView(entry: entry)
                    .padding(0).ignoresSafeArea()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Water Tracker")
        .description("Displays daily water intake progress.")
    }
}

