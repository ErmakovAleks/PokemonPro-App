//
//  AppDelegate.swift
//  PokemonPro-App
//
//  Created by Aleksandr Ermakov on 19.07.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        window?.rootViewController = ViewController()
        
        return true
    }
}

