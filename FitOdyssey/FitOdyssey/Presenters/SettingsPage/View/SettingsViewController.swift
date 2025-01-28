//
//  SettingsViewController.swift
//  FitOdyssey
//
//  Created by Giorgi on 18.01.25.
//

import UIKit
import SwiftUI
import FirebaseAuth

class SettingsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var settingsItems: [SettingsItem] = [
        SettingsItem(title: "Account", icon: "person.fill", color: .orange) { [weak self] in
            self?.navigateToProfile()
        },
        SettingsItem(title: "Password", icon: "lock.fill", color: .orange) { },
        SettingsItem(title: "Help", icon: "questionmark.circle.fill", color: .orange) { },
        SettingsItem(title: "Notifications", icon: "bell.fill", color: .orange) { },
        SettingsItem(title: "Feedback", icon: "envelope.fill", color: .orange) { },
        SettingsItem(title: "Report Bugs", icon: "ant.fill", color: .orange) { },
        SettingsItem(title: "Logout", icon: "rectangle.portrait.and.arrow.right", color: .red) { [weak self] in
            guard let self = self else { return }
               do {
                   try Auth.auth().signOut()
                   print("User logged out")
                   
                   let loginVC = LoginView()
                   let VCcontroler = UIHostingController(rootView: loginVC)
                   let navigationController = UINavigationController(rootViewController: VCcontroler)
                   navigationController.modalPresentationStyle = .fullScreen
                   self.present(navigationController, animated: true, completion: nil)
               } catch let error {
                   print("Failed to log out: \(error.localizedDescription)")
               }
        }
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .appBackground
        tableView.separatorStyle = .none
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func navigateToProfile() {
        let profileView = ProfileView()
        let hostingController = UIHostingController(rootView: profileView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        let item = settingsItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settingsItems[indexPath.row].action()
    }
}
