//
//  RecipeDetailViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/18/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailViewController: UIViewController {

    var recipe: Recipe!
    var apiUtils = RecipeMixAPIUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func saveRecipeAction(_ sender: Any) {
        
        if !apiUtils.validateExistingRecipe(recipeId: self.recipe.id!) {
            do {
                try apiUtils.saveRecipe(recipeToSave: self.recipe)
            } catch {
                let alertController = UIAlertController(title: "Error", message: "An error occurred while adding your recipe. Please, try again alter.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "The Recipe was already added.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func loadRecipesButtonAction(_ sender: Any) {
        
        let results = apiUtils.getSavedRecipes()
        print(results.count)
        
     }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
