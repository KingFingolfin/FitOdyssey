//
//  SharedImageViewModel.swift
//  FitOdyssey
//
//  Created by Giorgi on 01.02.25.
//


import UIKit
import FirebaseStorage
import Combine

final class SharedImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil

    func loadImage(from urlString: String) {
        guard URL(string: urlString) != nil else { return }

        let storageRef = Storage.storage().reference(forURL: urlString)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}