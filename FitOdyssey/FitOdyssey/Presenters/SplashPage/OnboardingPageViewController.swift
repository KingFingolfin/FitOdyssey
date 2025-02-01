//
//  OnboardingPageViewController.swift
//  FitOdyssey
//
//  Created by Giorgi on 01.02.25.
//
import UIKit

class OnboardingPageViewController: UIViewController {
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let getStartedButton = UIButton()
    private let glowView = UIView()
    
    var isLastPage: Bool = false {
        didSet {
            getStartedButton.isHidden = !isLastPage
            animateGlowIfNeeded()
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
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.appBackground.cgColor,
            UIColor.appBackground.withAlphaComponent(0.8).cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        containerView.backgroundColor = UIColor.appBackground.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.appOrange.withAlphaComponent(0.2).cgColor
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        glowView.backgroundColor = .clear
        glowView.layer.shadowColor = UIColor.appOrange.cgColor
        glowView.layer.shadowRadius = 30
        glowView.layer.shadowOpacity = 0.5
        view.addSubview(glowView)
        glowView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.9
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.textColor = .white.withAlphaComponent(0.8)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        setupEnhancedButton()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -20),
            
            glowView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            glowView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            glowView.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.2),
            glowView.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.2),
            
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            getStartedButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        addFloatingAnimation()
    }
    
    private func setupEnhancedButton() {
        getStartedButton.setTitle("Get Started", for: .normal)
        getStartedButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        getStartedButton.setTitleColor(.white, for: .normal)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.appOrange.cgColor,
            UIColor.appOrange.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 28
        getStartedButton.layer.insertSublayer(gradientLayer, at: 0)
        
        getStartedButton.layer.cornerRadius = 28
        getStartedButton.layer.shadowColor = UIColor.appOrange.cgColor
        getStartedButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        getStartedButton.layer.shadowRadius = 8
        getStartedButton.layer.shadowOpacity = 0.3
        
        getStartedButton.addTarget(self, action: #selector(getStartedButtonTapped), for: .touchUpInside)
        getStartedButton.isHidden = true
        view.addSubview(getStartedButton)
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addFloatingAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.duration = 2.0
        animation.fromValue = -5
        animation.toValue = 5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        imageView.layer.add(animation, forKey: "floating")
    }
    
    private func animateGlowIfNeeded() {
        guard isLastPage else { return }
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.glowView.layer.shadowOpacity = 0.8
        })
    }
    
    @objc private func getStartedButtonTapped() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.getStartedButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.getStartedButton.transform = .identity
            }
            self.onGetStartedTapped?()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
        if let gradientLayer = getStartedButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = getStartedButton.bounds
        }
    }
}
