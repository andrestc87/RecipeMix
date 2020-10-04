//
//  AuthViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/6/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

enum ProviderType: String {
    case basic
    case google
    case facebook
}

class AuthViewController: UIViewController {
    
    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        // Firebase Analytics Event
        Analytics.logEvent("InitInitialScreen", parameters: ["message":"Firebase integration with RecipeMix app completed"])
        
        // Verifies if the user is already logged
        let defaults = UserDefaults.standard
        
        if let email = defaults.value(forKey: "email") as? String, let provider = defaults.value(forKey: "provider") as? String {
            
            if let viewStack = authStackView {
                viewStack.isHidden = true
            }
            
            self.navigateToHome(email: email, error: nil, provider: ProviderType.init(rawValue: provider)!)
        }
        
        // Google Auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let viewStack = authStackView {
            viewStack.isHidden = false
        }
    }
    
    func displayInternetConnectionErrorDialog() {
        let errorAlert = RecipeMixUtils().createErrorAlertViewController(title: "Error", message: "You are offline. Please, check your internet connection.")
        
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                self.saveUserLoginInfo(email: email, provider: .basic)
                self.navigateToHome(email: email, error: error, provider: .basic)
            }
            
        } else {
            let errorAlert = RecipeMixUtils().createErrorAlertViewController(title: "Error", message: "Enter your Email and Password please.")
            
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                self.saveUserLoginInfo(email: email, provider: .basic)
                self.navigateToHome(email: email, error: error, provider: .basic)
            }
            
        } else {
            let errorAlert = RecipeMixUtils().createErrorAlertViewController(title: "Error", message: "Enter your Email and Password please.")
            
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func googleButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in

            switch result {
                case .success(granted: let granted, declined: let declined, token: let token):
                    let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                    Auth.auth().signIn(with: credential) { (result, error) in
                        self.saveUserLoginInfo(email: (result?.user.email)!, provider: .facebook)
                        self.navigateToHome(email: (result?.user.email)!, error: error, provider: .facebook)
                    }

                case .cancelled:
                    break

                case .failed(_):
                    break
            }
        }
    }
    
    private func navigateToHome(email: String, error: Error?, provider: ProviderType) {
        if error == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController") as! DashboardTabBarController
            mainTabBarController.email = email
            mainTabBarController.provider = ProviderType(rawValue: provider.rawValue)
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
        } else {
            let errorAlert = RecipeMixUtils().createErrorAlertViewController(title: "Error", message: "An error occurred authenticating the user using \(provider.rawValue)")
            
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func saveUserLoginInfo(email: String, provider: ProviderType) {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
    }
}

extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                self.saveUserLoginInfo(email: (result?.user.email)!, provider: .google)
                self.navigateToHome(email: (result?.user.email)!, error: error, provider: .google)
            }
        }
    }
}
