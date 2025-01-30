//
//  helpers.swift
//  FitOdyssey
//
//  Created by Giorgi on 15.01.25.
//

import SwiftUI

import UIKit

func getRootViewController() -> UIViewController {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          var rootViewController = window.rootViewController else {
        fatalError("Could not find root view controller.")
    }

    while let presented = rootViewController.presentedViewController {
        rootViewController = presented
    }

    return rootViewController
}

let workoutImages = ["image1", "image2", "image3"]
