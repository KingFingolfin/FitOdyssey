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
