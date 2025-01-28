//
//  ExerciseImageView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI
import FirebaseStorage

struct ExerciseImageView: View {
    let imageURL: String
    @State private var exerciseImage: UIImage? = nil
    
    var body: some View {
        if let image = exerciseImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(ProgressView().padding(), alignment: .center)
                .onAppear {
                    loadImage(from: imageURL)
                }
        }
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
