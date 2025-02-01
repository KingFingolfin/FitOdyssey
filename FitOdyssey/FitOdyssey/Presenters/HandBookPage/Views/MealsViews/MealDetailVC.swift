//
//  MealDetailVC.swift
//  FitOdyssey
//
//  Created by Giorgi on 16.01.25.
//

//import UIKit
//import FirebaseStorage

//class MealDetailVC: UIViewController {
//    var meal: Meal?
//    
//    private let scrollView = UIScrollView()
//    private let contentView = UIView()
//    private let mealImageView = UIImageView()
//    private let nameLabel = UILabel()
//    private let ingredientsTitleLabel = UILabel()
//    private let ingredientsLabel = UILabel()
//    private let ingredientsNumberLabel = UILabel()
//    private let recipeTitleLabel = UILabel()
//    private let recipeLabel = UILabel()
//    private let kcalLabel = UILabel()
//    private let levelLabel = UILabel()
//    private let timeLabel = UILabel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        configureMealDetails()
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .appBackground
//        
//        // Setup ScrollView
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scrollView)
//        
//        // Setup ContentView
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(contentView)
//        
//        // Setup ScrollView constraints
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
//        ])
//        
//        mealImageView.translatesAutoresizingMaskIntoConstraints = false
//        mealImageView.contentMode = .scaleAspectFill
//        mealImageView.clipsToBounds = true
//        contentView.addSubview(mealImageView)
//        
//        let features = [
//            (iconName: "clock", text: "15 min"),
//            (iconName: "ingreds", text: "5 ingredients"),
//            (iconName: "chef", text: "Easy")
//        ]
//        
//        let featureContainer = createFeatureContainer(features: features)
//        contentView.addSubview(featureContainer)
//        
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
//        nameLabel.textAlignment = .center
//        nameLabel.textColor = .white
//        nameLabel.numberOfLines = 0
//        contentView.addSubview(nameLabel)
//        
//        ingredientsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        ingredientsTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
//        ingredientsTitleLabel.textColor = .gray
//        ingredientsTitleLabel.text = "Ingredients"
//        contentView.addSubview(ingredientsTitleLabel)
//        
//        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
//        ingredientsLabel.font = UIFont.systemFont(ofSize: 18)
//        ingredientsLabel.textColor = .white
//        ingredientsLabel.numberOfLines = 0
//        contentView.addSubview(ingredientsLabel)
//        
//        recipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        recipeTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
//        recipeTitleLabel.textColor = .gray
//        recipeTitleLabel.text = "Recipe"
//        contentView.addSubview(recipeTitleLabel)
//        
//        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
//        recipeLabel.font = UIFont.systemFont(ofSize: 20)
//        recipeLabel.textColor = .white
//        recipeLabel.numberOfLines = 0
//        contentView.addSubview(recipeLabel)
//        
//        NSLayoutConstraint.activate([
//            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            mealImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            mealImageView.heightAnchor.constraint(equalToConstant: 300),
//            
//            nameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 20),
//            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            featureContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            featureContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
//            featureContainer.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
//            featureContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
//            
//            ingredientsTitleLabel.topAnchor.constraint(equalTo: featureContainer.bottomAnchor, constant: 30),
//            ingredientsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            ingredientsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            ingredientsLabel.topAnchor.constraint(equalTo: ingredientsTitleLabel.bottomAnchor, constant: 10),
//            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            recipeTitleLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 30),
//            recipeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            recipeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            recipeLabel.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: 10),
//            recipeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            recipeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            recipeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
//        ])
//    }
//    
//    private func createFeatureContainer(features: [(iconName: String, text: String)]) -> UIView {
//        let containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.backgroundColor = .appTabbarBack
//        containerView.layer.cornerRadius = 12
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        containerView.layer.shadowRadius = 4
//        containerView.layer.shadowOpacity = 0.2
//        
//        let container = UIStackView()
//        container.axis = .horizontal
//        container.alignment = .center
//        container.distribution = .fillEqually
//        container.spacing = 16
//        container.translatesAutoresizingMaskIntoConstraints = false
//        
//        containerView.addSubview(container)
//        
//        NSLayoutConstraint.activate([
//            container.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
//            container.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
//            container.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//            container.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
//        ])
//        
//        for feature in features {
//            let featureStack = UIStackView()
//            featureStack.axis = .vertical
//            featureStack.alignment = .center
//            featureStack.spacing = 8
//            featureStack.translatesAutoresizingMaskIntoConstraints = false
//            
//            let icon = UIImageView(image: UIImage(named: feature.iconName))
//            icon.contentMode = .scaleAspectFit
//            icon.translatesAutoresizingMaskIntoConstraints = false
//            icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
//            icon.tintColor = .appOrange
//            
//            let label = UILabel()
//            label.text = feature.text
//            label.textColor = .appOrange
//            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//            label.textAlignment = .center
//            label.numberOfLines = 1
//            
//            featureStack.addArrangedSubview(icon)
//            featureStack.addArrangedSubview(label)
//            
//            container.addArrangedSubview(featureStack)
//        }
//        
//        return containerView
//    }
//    
//    private func configureMealDetails() {
//        guard let meal = meal else { return }
//        
//        nameLabel.text = meal.name
//        ingredientsLabel.text = meal.ingredients
//        ingredientsNumberLabel.text = meal.ingredientsNumber
//        recipeLabel.text = meal.recipe
//        kcalLabel.text = "Calories: \(meal.kcal)"
//        timeLabel.text = "Time: \(meal.time)"
//        levelLabel.text = "Level: \(meal.level)"
//        
//        if !meal.image.isEmpty {
//            loadImage(from: meal.image)
//        }
//    }
//    
//    private func loadImage(from urlString: String) {
//        guard URL(string: urlString) != nil else { return }
//        
//        let storageRef = Storage.storage().reference(forURL: urlString)
//        storageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
//            if let error = error {
//                print("Error loading image: \(error.localizedDescription)")
//                return
//            }
//            if let data = data {
//                DispatchQueue.main.async {
//                    self?.mealImageView.image = UIImage(data: data)
//                }
//            }
//        }
//    }
//}

import UIKit
import Combine

class MealDetailVC: UIViewController {
    var meal: Meal?
    private var viewModel = SharedImageViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mealImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ingredientsTitleLabel = UILabel()
    private let ingredientsLabel = UILabel()
    private let ingredientsNumberLabel = UILabel()
    private let recipeTitleLabel = UILabel()
    private let recipeLabel = UILabel()
    private let kcalLabel = UILabel()
    private let levelLabel = UILabel()
    private let timeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        if let meal = meal {
            configureMealDetails(meal: meal)
            viewModel.loadImage(from: meal.image)
        }
    }

    private func setupUI() {
        view.backgroundColor = .appBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.clipsToBounds = true
        contentView.addSubview(mealImageView)

        let features = [
            (iconName: "clock", text: "15 min"),
            (iconName: "ingreds", text: "5 ingredients"),
            (iconName: "chef", text: "Easy")
        ]

        let featureContainer = createFeatureContainer(features: features)
        contentView.addSubview(featureContainer)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)

        ingredientsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        ingredientsTitleLabel.textColor = .gray
        ingredientsTitleLabel.text = "Ingredients"
        contentView.addSubview(ingredientsTitleLabel)

        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.font = UIFont.systemFont(ofSize: 18)
        ingredientsLabel.textColor = .white
        ingredientsLabel.numberOfLines = 0
        contentView.addSubview(ingredientsLabel)

        recipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        recipeTitleLabel.textColor = .gray
        recipeTitleLabel.text = "Recipe"
        contentView.addSubview(recipeTitleLabel)

        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeLabel.font = UIFont.systemFont(ofSize: 20)
        recipeLabel.textColor = .white
        recipeLabel.numberOfLines = 0
        contentView.addSubview(recipeLabel)

        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: 300),

            nameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            featureContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            featureContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            featureContainer.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
            featureContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),

            ingredientsTitleLabel.topAnchor.constraint(equalTo: featureContainer.bottomAnchor, constant: 30),
            ingredientsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            ingredientsLabel.topAnchor.constraint(equalTo: ingredientsTitleLabel.bottomAnchor, constant: 10),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            recipeTitleLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 30),
            recipeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            recipeLabel.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: 10),
            recipeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recipeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func setupBindings() {
            viewModel.$image
                .receive(on: DispatchQueue.main)
                .sink { [weak self] image in
                    self?.mealImageView.image = image
                }
                .store(in: &cancellables)
        }

    private func configureMealDetails(meal: Meal) {
        nameLabel.text = meal.name
        ingredientsLabel.text = meal.ingredients
        ingredientsNumberLabel.text = meal.ingredientsNumber
        recipeLabel.text = meal.recipe
        kcalLabel.text = "Calories: \(meal.kcal)"
        timeLabel.text = "Time: \(meal.time)"
        levelLabel.text = "Level: \(meal.level)"
    }

    private func createFeatureContainer(features: [(iconName: String, text: String)]) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .appTabbarBack
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.2
        
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.distribution = .fillEqually
        container.spacing = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            container.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            container.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        for feature in features {
            let featureStack = UIStackView()
            featureStack.axis = .vertical
            featureStack.alignment = .center
            featureStack.spacing = 8
            featureStack.translatesAutoresizingMaskIntoConstraints = false
            
            let icon = UIImageView(image: UIImage(named: feature.iconName))
            icon.contentMode = .scaleAspectFit
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
            icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
            icon.tintColor = .appOrange
            
            let label = UILabel()
            label.text = feature.text
            label.textColor = .appOrange
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textAlignment = .center
            label.numberOfLines = 1
            
            featureStack.addArrangedSubview(icon)
            featureStack.addArrangedSubview(label)
            
            container.addArrangedSubview(featureStack)
        }
        
        return containerView
    }
}
