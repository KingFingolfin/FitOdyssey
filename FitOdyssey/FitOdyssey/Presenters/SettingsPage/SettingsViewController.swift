//
//  SettingsViewController.swift
//  FitOdyssey
//
//  Created by Giorgi on 18.01.25.
//

import UIKit
import SwiftUI
import FirebaseAuth

// Custom colors extension
extension UIColor {
    static let darkBackground = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
    static let cellBackground = UIColor(red: 0.15, green: 0.15, blue: 0.16, alpha: 1.0)
    static let iconTint = UIColor(red: 1.0, green: 0.47, blue: 0.31, alpha: 1.0)
}

struct SettingsItem {
    let title: String
    let icon: String // SF Symbol name
    let color: UIColor
    let action: () -> Void
}

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
                   try Auth.auth().signOut() // Sign out the user from Firebase
                   print("User logged out")
                   
                   // Redirect to LoginViewController
                   let loginVC = LoginView() // Replace with your actual login VC
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
        
        // Configure table view
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
        @State var show = true
        let profileView = ProfileView(showProfile: $show)
        let hostingController = UIHostingController(rootView: profileView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
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
        return 70 // Increased cell height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settingsItems[indexPath.row].action()
    }
}

// MARK: - Custom Cell
class SettingsCell: UITableViewCell {
    private let iconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        view.layer.cornerRadius = 25 // Make it round (half of the container size)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18) // Increased font size
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .appBackground
        selectionStyle = .none
        
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 50), // Increased container size
            iconContainer.heightAnchor.constraint(equalToConstant: 50), // Increased container size
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24), // Increased icon size
            iconImageView.heightAnchor.constraint(equalToConstant: 24), // Increased icon size
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with item: SettingsItem) {
        titleLabel.text = item.title
        iconImageView.image = UIImage(systemName: item.icon)
        iconImageView.tintColor = item.color
        
        // Special styling for logout
        if item.title == "Logout" {
            titleLabel.textColor = .red
        } else {
            titleLabel.textColor = .white
        }
    }
}
