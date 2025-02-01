//
//  OnboardingPageViewController.swift
//  FitOdyssey
//
//  Created by Giorgi on 01.02.25.
//

import UIKit

class OnboardingPageViewController: UIViewController {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let getStartedButton = UIButton()

    var isLastPage: Bool = false {
        didSet {
            getStartedButton.isHidden = !isLastPage
        }
    }

    var onGetStartedTapped: (() -> Void)?

    init(imageName: String, title: String, description: String) {
        super.init(nibName: nil, bundle: nil)
        setupUI(imageName: imageName, title: title, description: description)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(imageName: String, title: String, description: String) {
        view.backgroundColor = UIColor.black

        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = UIColor.orange
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        getStartedButton.setTitle("Get Started", for: .normal)
        getStartedButton.setTitleColor(.black, for: .normal)
        getStartedButton.backgroundColor = .orange
        getStartedButton.layer.cornerRadius = 12
        getStartedButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        getStartedButton.addTarget(self, action: #selector(getStartedButtonTapped), for: .touchUpInside)
        getStartedButton.isHidden = true
        view.addSubview(getStartedButton)
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getStartedButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    @objc private func getStartedButtonTapped() {
        onGetStartedTapped?()
    }
}
