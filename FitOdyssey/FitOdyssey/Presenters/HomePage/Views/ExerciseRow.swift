//
//  ExerciseRow.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//
import SwiftUI
import Combine

struct ExerciseRow: View {
    let exercise: Exercise
    let isSelected: Bool
    let onTap: () -> Void
    
    @StateObject private var viewModel = SharedImageViewModel()
    
    var body: some View {
        HStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .overlay(ProgressView().padding(), alignment: .center)
                    .onAppear {
                        viewModel.loadImage(from: exercise.image)
                    }
            }
            
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .green : .gray)
        }
        .contentShape(Rectangle())
        .padding(.horizontal)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .onTapGesture(perform: onTap)
    }
}
