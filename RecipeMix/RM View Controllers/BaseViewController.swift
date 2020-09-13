//
//  BaseViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/11/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var email: String!
    var provider: ProviderType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarVC = self.tabBarController as? DashboardTabBarController {
            self.email = tabBarVC.email
            self.provider = tabBarVC.provider
        }
        
        // Save the User Session
        saveUserLoginInfo()
    }
    
    func saveUserLoginInfo() {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
    }
    
    @IBAction func signOutButtonAction(_ sender: Any) {
        print("Sign Out FROM BASE")
    
    }

}
