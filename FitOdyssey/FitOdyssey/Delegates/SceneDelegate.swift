//
//  SceneDelegate.swift
//  FitOdyssey
//
//  Created by Giorgi on 12.01.25.
//

import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let root = SplashViewController()
        window.rootViewController = root
        self.window = window
        window.makeKeyAndVisible()
    }
}

