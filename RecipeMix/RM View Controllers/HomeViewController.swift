//
//  HomeViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/6/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

enum ProviderType: String {
    case basic
    case google
    case facebook
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    var email: String!
    var provider: ProviderType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Home"
        navigationItem.setHidesBackButton(true, animated: false)
        emailLabel.text = email
        providerLabel.text = provider.rawValue
        
        // Save the User Session
        saveUserLoginInfo()
    }
    
    func saveUserLoginInfo() {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        
        deleteUserLoginInfo()
        
        switch provider {
        
        case .basic:
            fireBaseSignOut()
        
        case .google:
            GIDSignIn.sharedInstance()?.signOut()
            fireBaseSignOut()
        
        case .facebook:
            LoginManager().logOut()
            fireBaseSignOut()
        
        case .none:
            print("None")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteUserLoginInfo() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
    }
    
    private func fireBaseSignOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            // TODO: Create generic way to handle error messages
            print("Error signing out the user")
        }
    }
    
}
