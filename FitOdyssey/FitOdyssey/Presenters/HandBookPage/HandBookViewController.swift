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
            navigationController?.setNavigationBarHidden(false, animated: true)
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
            
           
            let exercisesBlock = createBlock(title: "Exercises", backgroundColor: .systemBlue)
            exercisesBlock.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exercisesTapped)))
            stackView.addArrangedSubview(exercisesBlock)
            
           
            let mealsBlock = createBlock(title: "Meals", backgroundColor: .systemGreen)
            mealsBlock.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mealsTapped)))
            stackView.addArrangedSubview(mealsBlock)
        }
        
        private func createBlock(title: String, backgroundColor: UIColor) -> UIView {
            let block = UIView()
            block.backgroundColor = backgroundColor
            block.layer.cornerRadius = 10
            block.translatesAutoresizingMaskIntoConstraints = false
            block.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            let label = UILabel()
            label.text = title
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 24)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            block.addSubview(label)
            
            NSLayoutConstraint.activate([
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

    
    class ExercisesVC: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .red
            title = "Exercises"
        }
    }



import SwiftUI

struct HandBookViewController_Preview: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    struct Preview: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            HandBookViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
}
