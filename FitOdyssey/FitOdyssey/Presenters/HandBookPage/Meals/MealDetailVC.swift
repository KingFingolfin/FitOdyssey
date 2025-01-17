//
//  MealDetailVC.swift
//  FitOdyssey
//
//  Created by Giorgi on 16.01.25.
//


import UIKit
import FirebaseStorage

class MealDetailVC: UIViewController {
    var meal: Meal?

    private let mealImageView = UIImageView()
    private let nameLabel = UILabel()
    private let recipeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureMealDetails()
    }

    private func setupUI() {
        view.backgroundColor = .appBackground

        
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.clipsToBounds = true
        view.addSubview(mealImageView)

        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        view.addSubview(nameLabel)

        
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeLabel.font = UIFont.systemFont(ofSize: 20)
        recipeLabel.textColor = .white
        recipeLabel.numberOfLines = 0
        view.addSubview(recipeLabel)

        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mealImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mealImageView.widthAnchor.constraint(equalToConstant: 200),
            mealImageView.heightAnchor.constraint(equalToConstant: 200),

            nameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            recipeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            recipeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recipeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func configureMealDetails() {
        guard let meal = meal else { return }
        nameLabel.text = meal.name
        recipeLabel.text = meal.recipe

        
        if !meal.image.isEmpty {
            loadImage(from: meal.image)
        }
    }


    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        
        let storageRef = Storage.storage().reference(forURL: urlString)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self?.mealImageView.image = UIImage(data: data)
                }
            }
        }
    }
}

