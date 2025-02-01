//
//  helpers.swift
//  FitOdyssey
//
//  Created by Giorgi on 15.01.25.
//

import UIKit
import SwiftUI

func getRootViewController() -> UIViewController {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          var rootViewController = window.rootViewController else {
        fatalError("no rootControler found")
    }

    while let presented = rootViewController.presentedViewController {
        rootViewController = presented
    }

    return rootViewController
}

class OnboardingManager {
    static let shared = OnboardingManager()
    private let hasOnboardedKey = "hasOnboarded"
    
    var hasOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hasOnboardedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasOnboardedKey)
        }
    }
}

let workoutImages = ["image1", "image2", "image3"]
