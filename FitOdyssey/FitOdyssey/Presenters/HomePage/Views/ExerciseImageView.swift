//
//  ExerciseImageView.swift
//  FitOdyssey
//
//  Created by Giorgi on 28.01.25.
//

import SwiftUI

struct ExerciseImageView: View {
    let imageURL: String
    @StateObject private var viewModel = SharedImageViewModel()
    
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(ProgressView().padding(), alignment: .center)
                .onAppear {
                    viewModel.loadImage(from: imageURL)
                }
        }
    }
}
