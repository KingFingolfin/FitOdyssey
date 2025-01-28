//
//  ExerciseRow.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI
import FirebaseStorage

struct ExerciseRow: View {
    let exercise: Exercise
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var exerciseImage: UIImage? = nil
    
    var body: some View {
        HStack {
            if let image = exerciseImage {
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
                        loadImage(from: exercise.image)
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
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let storageRef = Storage.storage().reference(forURL: url.absoluteString)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.exerciseImage = image
                }
            }
        }
    }
}
