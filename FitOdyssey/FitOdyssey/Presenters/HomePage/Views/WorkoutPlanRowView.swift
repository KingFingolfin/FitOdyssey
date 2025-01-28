//
//  WorkoutPlanRowView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//
import SwiftUI

struct WorkoutPlanRowView: View {
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
