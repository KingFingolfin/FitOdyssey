//
//  ExercisesDetailVC.swift
//  FitOdyssey
//
//  Created by Giorgi on 16.01.25.
//


import UIKit
import Combine

class ExercisesDetailVC: UIViewController {
    var exercise: Exercise?
    private var viewModel = SharedImageViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let exerciseImageView = UIImageView()
    private let nameLabel = UILabel()
    private let instructionsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        if let exercise = exercise {
            configureExerciseDetails(exercise: exercise)
            viewModel.loadImage(from: exercise.image)
        }
    }

    private func setupUI() {
        view.backgroundColor = .appBackground

        exerciseImageView.translatesAutoresizingMaskIntoConstraints = false
        exerciseImageView.contentMode = .scaleAspectFill
        exerciseImageView.clipsToBounds = true
        view.addSubview(exerciseImageView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        view.addSubview(nameLabel)

        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.font = UIFont.systemFont(ofSize: 18)
        instructionsLabel.textColor = .white
        instructionsLabel.numberOfLines = 0
        view.addSubview(instructionsLabel)

        NSLayoutConstraint.activate([
            exerciseImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            exerciseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exerciseImageView.widthAnchor.constraint(equalToConstant: 200),
            exerciseImageView.heightAnchor.constraint(equalToConstant: 200),

            nameLabel.topAnchor.constraint(equalTo: exerciseImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            instructionsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func setupBindings() {
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.exerciseImageView.image = image
            }
            .store(in: &cancellables)
    }

    private func configureExerciseDetails(exercise: Exercise) {
        nameLabel.text = exercise.name
        instructionsLabel.text = exercise.instructions
    }
}
