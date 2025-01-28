//
//  SelectedExercisesView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI

struct SelectedExercisesView: View {
    let selectedExercises: Set<Exercise>
    
    var body: some View {
        Group {
            if !selectedExercises.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(selectedExercises)) { exercise in
                            Text(exercise.name)
                                .padding(8)
                                .foregroundStyle(.white)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
