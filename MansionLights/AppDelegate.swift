//
//  AppDelegate.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 18/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit

protocol AppDelegateLayoutProtocol {
    func navigationBarLayout()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        navigationBarLayout()

        return true
    }
}

extension AppDelegate: AppDelegateLayoutProtocol {
    func navigationBarLayout() {
        UINavigationBar.appearance().barTintColor = UIColor().hexToColor(hexString: "15161D")
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
