//
//  AppDelegate.swift
//  Course2FinalTask
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = UITabBarController()        
        
        let feedViewController = FeedViewController()
        let profileViewController = ProfileViewController(user: DataProviders.shared.usersDataProvider.currentUser())
        
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        feedViewController.title = "Feed"
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.title = "Profile"
        
        tabBarController.viewControllers = [feedNavigationController, profileNavigationController]
        feedNavigationController.tabBarItem.image = #imageLiteral(resourceName: "feed")
        profileNavigationController.tabBarItem.image = #imageLiteral(resourceName: "profile")
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}
