//
//  HandBookViewController.swift
//  FitOdyssey
//
//  Created by Giorgi on 16.01.25.
//

import UIKit

class HandBookViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        setupUI()
        if let backButton = navigationController?.navigationBar.topItem?.backBarButtonItem {
            backButton.tintColor = .orange
        }
        navigationController?.navigationBar.tintColor = .orange
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        
        let exercisesBlock = createBlock(title: "Exercises")
        
        exercisesBlock.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exercisesTapped)))
        stackView.addArrangedSubview(exercisesBlock)
        
        let mealsBlock = createBlock(title: "Meals")
        mealsBlock.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mealsTapped)))
        stackView.addArrangedSubview(mealsBlock)
        
    }
    
    private func createBlock(title: String) -> UIView {
        let block = UIView()
        block.layer.cornerRadius = 10
        block.layer.masksToBounds = true
        block.translatesAutoresizingMaskIntoConstraints = false
        block.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        var imageView = UIImageView(image: UIImage(named: "MealsBack"))
        if title == "Exercises" {
            imageView = UIImageView(image: UIImage(named: "ExerciseBack"))
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        block.addSubview(imageView)
        
        
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.layer.cornerRadius = 10
        overlay.translatesAutoresizingMaskIntoConstraints = false
        block.addSubview(overlay)
        
        
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        block.addSubview(label)
        
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: block.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: block.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: block.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: block.bottomAnchor),
            
            overlay.topAnchor.constraint(equalTo: block.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: block.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: block.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: block.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: block.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: block.centerYAnchor)
        ])
        
        return block
    }
    
    @objc private func exercisesTapped() {
        let exercisesVC = ExercisesVC()
        
        navigationController?.pushViewController(exercisesVC, animated: true)
    }
    
    @objc private func mealsTapped() {
        let mealsVC = MealsVC()
        navigationController?.pushViewController(mealsVC, animated: true)
    }
}
