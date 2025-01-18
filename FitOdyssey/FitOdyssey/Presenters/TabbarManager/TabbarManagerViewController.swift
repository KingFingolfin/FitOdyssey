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
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home")
        )
 
        let bookVC = HandBookViewController()
        bookVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "book"),
            selectedImage: UIImage(named: "book")
        )
        
        let progressView = ProgressPageView()
        let progressHostingController = UIHostingController(rootView: progressView)
        progressHostingController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "progress"),
            selectedImage: UIImage(named: "progress")
        )
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "settings"),
            selectedImage: UIImage(named: "settings")
        )
        self.viewControllers = [homeHostingController, bookVC, progressHostingController , settingsVC]
        
        
        tabBar.tintColor = .orange
        tabBar.unselectedItemTintColor = .gray
        
        tabBar.items?.forEach { item in
                item.title = nil
                item.imageInsets = .zero  // Reset any existing insets
            }
    }
    
    
    private func customizeTabBarAppearance() {
        tabBar.backgroundColor = .appTabbarBack

        // Set a corner radius to make it look like a long circle
        tabBar.layer.cornerRadius = 30
        tabBar.layer.masksToBounds = true

        // Optionally, add a border to the tab bar
        tabBar.layer.borderColor = UIColor.darkGray.cgColor
        tabBar.layer.borderWidth = 1
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var tabBarFrame = tabBar.frame
        tabBarFrame.size.height = 50
        tabBarFrame.size.width = view.frame.width - 40
        tabBarFrame.origin.y = view.frame.height - 80
        tabBarFrame.origin.x = (view.frame.width - tabBarFrame.size.width) / 2
        tabBar.frame = tabBarFrame

        tabBar.layer.cornerRadius = tabBarFrame.height / 2

        // Configure image sizes and position
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
                
                // Configure the size for custom images
                let imageSize: CGFloat = 24  // You can adjust this value
                if let originalImage = item.image {
                    let newImage = resizeImage(originalImage, targetSize: CGSize(width: imageSize, height: imageSize))
                    item.image = newImage
                }
                if let originalSelectedImage = item.selectedImage {
                    let newSelectedImage = resizeImage(originalSelectedImage, targetSize: CGSize(width: imageSize, height: imageSize))
                    item.selectedImage = newSelectedImage
                }
            }
        }
    }

    // Add this helper method to resize images
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }



}


struct TabBarWrapperView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TabBarViewController {
        return TabBarViewController()
    }
    
    func updateUIViewController(_ uiViewController: TabBarViewController, context: Context) {
    }
}
