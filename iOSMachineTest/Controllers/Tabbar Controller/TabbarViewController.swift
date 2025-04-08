//
//  TabbarViewController.swift
//  iOSMachineTest
//
//  Created by Anil Yadav on 12/03/25.
//  Email: anilyadavjnt@gmail.com
//  Contact No: +91-975211420
//

import UIKit

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupTabBarShadow()
    }
    
    private func setupTabBar() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "homekit"), selectedImage: UIImage(systemName: "homekit"))
        
        let favouriteVC = FavouriteViewController()
        favouriteVC.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart.fill"), selectedImage: UIImage(systemName: "heart.fill"))
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let upcomingNav = UINavigationController(rootViewController: favouriteVC)
        
        viewControllers = [homeNav, upcomingNav]
        
        view.backgroundColor = .white
        // Customizing Tab Bar appearance
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemRed
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemRed]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func setupTabBarShadow() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow at top
        tabBar.layer.shadowRadius = 4
        tabBar.layer.masksToBounds = false
    }
}
