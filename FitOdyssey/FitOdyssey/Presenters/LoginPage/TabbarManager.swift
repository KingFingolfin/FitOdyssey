//
//  TabbarManager.swift
//  FitOdyssey
//
//  Created by Giorgi on 16.01.25.
//


//import SwiftUI
//
//struct TabBarWrapperView: UIViewControllerRepresentable {
//    @Binding var showProfile: Bool
//
//    func makeUIViewController(context: Context) -> UITabBarController {
//        let tabBarController = UITabBarController()
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
//
//        let backgroundView = UIView(frame: gradientLayer.frame)
//        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
//        tabBarController.tabBar.insertSubview(backgroundView, at: 0)
//        tabBarController.tabBar.backgroundColor = .clear
//        tabBarController.tabBar.clipsToBounds = true
//
//        // Make tab bar rounded
//        tabBarController.tabBar.layer.cornerRadius = 10
//        tabBarController.tabBar.layer.masksToBounds = true
//        tabBarController.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//
//        // Configure appearance for items
//        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = .clear // Use the gradient as the background
//        appearance.stackedLayoutAppearance.normal.iconColor = .gray // not selected images
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
//        appearance.stackedLayoutAppearance.selected.iconColor = .orange
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
//            .foregroundColor: UIColor.gradientColor(
//                colors: [UIColor.orange, UIColor.white],
//                size: CGSize(width: 40, height: 40)
//            )
//        ]
//        tabBarController.tabBar.standardAppearance = appearance
//        tabBarController.tabBar.scrollEdgeAppearance = appearance
//
//        // Home (SwiftUI)
//        let homeView = HomeView()
//        let homeHostingController = UIHostingController(rootView: homeView)
//        
//        // Profile (SwiftUI with Binding)
//        let profileView = ProfileView(showProfile: $showProfile)
//        let profileHostingController = UIHostingController(rootView: profileView)
//        
//        // UIKit view controllers
//        let settingsViewController = SettingsViewController()
//        let handBookViewController = HandBookViewController()
//        
//        // Tab bar items
//        homeHostingController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
//        handBookViewController.tabBarItem = UITabBarItem(title: "Handbook", image: UIImage(systemName: "book"), tag: 0)
//        profileHostingController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
//        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
//        
//        // Assign view controllers to the tab bar
//        tabBarController.viewControllers = [homeHostingController, handBookViewController, settingsViewController, profileHostingController]
//        return tabBarController
//    }
//    
//    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
//    }
//}

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        customizeTabBarAppearance()
        self.delegate = self
    }
 
    private func setupTabBar() {
        let homeView = HomeView()
        let homeHostingController = UIHostingController(rootView: homeView)
        homeHostingController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house.fill"),
            selectedImage: UIImage(systemName: "house.fill")
        )
 
        let mealsPageVC = HandBookViewController()
        mealsPageVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book")
        )
        
        @State var showProfule = true
        let profileView = ProfileView(showProfile: $showProfule)
        let profileHostingController = UIHostingController(rootView: profileView)
        profileHostingController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "person.fill"),
            selectedImage: UIImage(systemName: "person.fill")
        )
 
        self.viewControllers = [homeHostingController, mealsPageVC, profileHostingController]
       
 
        if let items = tabBar.items {
            for (index, item) in items.enumerated() {
                if index == 4 {
                    item.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
                } else {
                    item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
                }
            }
        }
 
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
    }
 
    private func customizeTabBarAppearance() {
        tabBar.backgroundColor = .appBackground
        
        let divider = UIView(frame: CGRect(x: 0, y: -2, width: tabBar.bounds.width, height: 0.5))
        divider.backgroundColor = UIColor(hex: "000000").withAlphaComponent(0.1)
//        tabBar.addSubview(divider)
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        var tabBarFrame = tabBar.frame
        tabBarFrame.size.height = 79
        tabBarFrame.origin.y = view.frame.height - 79
        tabBar.frame = tabBarFrame
    }
}
 
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
 
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
 
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
 
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
 
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let isProfileSelected = tabBarController.selectedIndex == 4
    }
}


struct TabBarWrapperView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TabBarViewController {
        return TabBarViewController()
    }
    
    func updateUIViewController(_ uiViewController: TabBarViewController, context: Context) {
    }
}
