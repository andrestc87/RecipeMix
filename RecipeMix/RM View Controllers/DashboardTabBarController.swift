//
//  DashboardTabBarController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/12/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class DashboardTabBarController: UITabBarController {

    var email: String!
    var provider: ProviderType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.isHidden = true

        // Save the User Session
        saveUserLoginInfo()
    }
    
    func saveUserLoginInfo() {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
    }

}
