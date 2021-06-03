//
//  MainTabBarController.swift
//  CourseworkChat
//
//  Created by Admin on 17.05.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.layer.masksToBounds = true
        self.tabBar.barStyle = .black
        self.tabBar.barTintColor = .black
        self.tabBar.tintColor = UIColor.white
    }
    
    deinit {
        self.viewControllers?.removeAll()
    }
    
}
