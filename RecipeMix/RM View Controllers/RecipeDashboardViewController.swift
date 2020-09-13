//
//  RecipeDashboardViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/11/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class RecipeDashboardViewController: BaseViewController {
    
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutButtonAction(_ sender: Any) {
        
        print("Sign Out")
        print("Get Recipes")
        
        let tagsSample = "chicken"
        
        RecipeMixClient.recipeMixSharedInstance.searchRecipeMixRecipes(tags: tagsSample, page: 5) { (recipes, error) in
            print("FROM DASHBOARD")
            
            if error != nil {
                let errorAlert = RecipeMixUtils().createErrorAlertViewController(title: "Error", message: "There was an error trying to search recipes. Please try again.")
                
                self.present(errorAlert, animated: true)
            } else {
                self.recipes = recipes ?? []
            }
        }
    }
    
}
