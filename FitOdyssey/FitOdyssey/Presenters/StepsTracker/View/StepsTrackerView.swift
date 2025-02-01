//
//  StepsTrackerView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//


import SwiftUI

struct StepsTrackerView: View {
    @StateObject private var viewModel = StepsTrackerViewModel()

    var body: some View {
        VStack {
            if viewModel.isHealthDataAvailable {
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.stepCount / viewModel.goal))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.appOrange)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 200, height: 200)
                    .overlay(
                        Text("\(Int(viewModel.stepCount))")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    )
                    .padding()

               
                Text("Step Goal: \(Int(viewModel.goal))")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()

            } else {
                Text("Health Data Not Available")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear {
            
            viewModel.fetchStepsData()
        }
    }
}
