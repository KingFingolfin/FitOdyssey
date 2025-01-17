//
//  SplashViewController.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//

import UIKit
import SwiftUI

class SplashViewController: UIViewController {
    private let imageView = UIImageView()
    private let name = UILabel()
    private let slogan = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        imageSetup()
        textSetup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.goToNextPage()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.goToNextPage()
        }
    }

    
    private func imageSetup() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "MainLogo")
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 3),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func textSetup() {
        view.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        name.text = "FITODYSSEY"
        name.textColor = .white
        name.font = .boldSystemFont(ofSize: 24)
        
        view.addSubview(slogan)
        slogan.translatesAutoresizingMaskIntoConstraints = false
        
        slogan.text = "Journey starts here"
        slogan.textColor = .systemGray
        slogan.font = .systemFont(ofSize: 14)
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slogan.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
            slogan.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func goToNextPage() {
            let loginView = LoginView()
            let hostingController = UIHostingController(rootView: loginView)
            
            hostingController.modalTransitionStyle = .crossDissolve
            hostingController.modalPresentationStyle = .fullScreen
            self.present(hostingController, animated: true, completion: nil)
        }
}
