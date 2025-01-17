//
//  TabbarManager.swift
//  FitOdyssey
//
//  Created by Giorgi on 16.01.25.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        customizeTabBarAppearance()
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
        
        let PageVC = HandBookViewController()
        PageVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book")
        )
        
        @State var showProfile = true
        let profileView = ProfileView(showProfile: $showProfile)
        let profileHostingController = UIHostingController(rootView: profileView)
        profileHostingController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "person.fill"),
            selectedImage: UIImage(systemName: "person.fill")
        )
 
        self.viewControllers = [homeHostingController, mealsPageVC, profileHostingController, PageVC]
 
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
    }
    
    private func customizeTabBarAppearance() {
            tabBar.backgroundColor = .black
            
            // Set a corner radius to make it look like a long circle
            tabBar.layer.cornerRadius = 30
            tabBar.layer.masksToBounds = true
            // Optionally, add a border to the tab bar
            tabBar.layer.borderColor = UIColor.darkGray.cgColor
            tabBar.layer.borderWidth = 1
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            // Adjust the tabBar frame to make it shorter and add margins
            var tabBarFrame = tabBar.frame
            tabBarFrame.size.height = 50 // Adjust height
            tabBarFrame.size.width = view.frame.width - 40 // Add margins (20px on each side)
            tabBarFrame.origin.y = view.frame.height - 80
            tabBarFrame.origin.x = (view.frame.width - tabBarFrame.size.width) / 2
            tabBar.frame = tabBarFrame
            
            // Ensure the corner radius matches the height for a smooth curve
            tabBar.layer.cornerRadius = tabBarFrame.height / 2
        }
}


struct TabBarWrapperView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TabBarViewController {
        return TabBarViewController()
    }
    
    func updateUIViewController(_ uiViewController: TabBarViewController, context: Context) {
    }
}
