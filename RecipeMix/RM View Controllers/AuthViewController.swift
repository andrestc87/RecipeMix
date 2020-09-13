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
        // Do any additional setup after loading the view.
        title = "Login"
        
        // Firebase Analytics Event
        Analytics.logEvent("InitInitialScreen", parameters: ["message":"Firebase integration with RecipeMix app completed"])
        
        // Verifies if the user is already logged
        let defaults = UserDefaults.standard
        
        // TODO: Extract this code to a new function
        if let email = defaults.value(forKey: "email") as? String, let provider = defaults.value(forKey: "provider") as? String {
            
            if let viewStack = authStackView {
                viewStack.isHidden = true
            }
            
            //let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardTabBarIdentifier") as! DashboardTabBarController
            homeVC.email = email
            homeVC.provider = ProviderType.init(rawValue: provider)!
            
            self.navigationController?.pushViewController(homeVC, animated: false)
            
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
    
    // TODO: Refactor login code
    @IBAction func registerButtonAction(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                self.navigateToHome(result: result, error: error, provider: .basic)
            }
            
        } else {
            //TODO
            //Add logic to validate if one of the fields is missing
        }
    
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                self.navigateToHome(result: result, error: error, provider: .basic)
            }
            
        } else {
            //TODO
            //Add logic to validate if one of the fields is missing
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
                    self.navigateToHome(result: result, error: error, provider: .facebook)
                }
            
            case .cancelled:
                break
            
            case .failed(_):
                break
        }
        
        }
    }
    
    private func navigateToHome(result: AuthDataResult?, error: Error?, provider: ProviderType) {
        
        if let result = result, error == nil {
            //let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardTabBarIdentifier") as! DashboardTabBarController
            homeVC.email = result.user.email
            homeVC.provider = provider
            
            self.navigationController?.pushViewController(homeVC, animated: true)
            
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "An error occurred authenticating the user using \(provider.rawValue)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}


extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                self.navigateToHome(result: result, error: error, provider: .google)
            }
        }
    }
    
}
