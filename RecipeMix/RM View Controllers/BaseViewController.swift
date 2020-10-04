//
//  BaseViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/11/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class BaseViewController: UIViewController {
    
    var email: String!
    var provider: ProviderType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarVC = self.tabBarController as? DashboardTabBarController {
            self.email = tabBarVC.email
            self.provider = tabBarVC.provider
        }
    }
    
    @IBAction func signOutButtonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out from RecipeMix?", preferredStyle: .alert)

        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] action in
            
            self?.deleteUserLoginInfo()
            
            switch self?.provider {
            
            case .basic:
                self?.fireBaseSignOut()
            
            case .google:
                GIDSignIn.sharedInstance()?.signOut()
                self?.fireBaseSignOut()
            
            case .facebook:
                LoginManager().logOut()
                self?.fireBaseSignOut()
            
            case .none:
                print("None")
            }
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        } catch {
            displaySignOutErrorMessage()
        }
    }
    
    func displaySignOutErrorMessage() {
        let errorAlert = RecipeMixUtils().createErrorAlertViewController(title: "Error", message: "An error occurred while signing out. Please, try again.")
        
        self.present(errorAlert, animated: true, completion: nil)
    }

}
