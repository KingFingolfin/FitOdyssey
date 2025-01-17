//
//  helpers.swift
//  FitOdyssey
//
//  Created by Giorgi on 15.01.25.
//

import SwiftUI

import UIKit

//func getRootViewController() -> UIViewController {
//    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//          let rootViewController = windowScene.windows.first?.rootViewController else {
//        fatalError("Could not find root view controller.")
//    }
//    return rootViewController
//}

func getRootViewController() -> UIViewController {
    var rootViewController = UIApplication.shared.windows.first?.rootViewController

    while let presented = rootViewController?.presentedViewController {
        rootViewController = presented
    }

    guard let finalRootViewController = rootViewController else {
        fatalError("Could not find root view controller.")
    }
    return finalRootViewController
}

