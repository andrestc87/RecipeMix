//
//  RecipeViewController.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/20/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import CoreData
import SkeletonView
import Kingfisher

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var addRecipeButton: UIButton!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipePriceLabel: UILabel!
    @IBOutlet weak var recipeTimeLabel: UILabel!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var viewIngredientsButton: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var instructionsContentLabel: UILabel!
    
    
    var recipe: Recipe!
    var apiUtils = RecipeMixAPIUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recipe"
        self.navigationItem.largeTitleDisplayMode = .never
        // Use this validation to determine if the information is going to be from the dashboard or from the data stored on the device
        //if !apiUtils.validateExistingRecipe(recipeId: self.recipe.id!) {
        setupRecipeContent()
        print(recipe.image)
    }
    
    func setupRecipeContent() {
        //Recipe Image View
        self.recipeImageView.showAnimatedGradientSkeleton()
        // Using Kingsfire to load images
        if let imageUrl = self.recipe.image {
            let resourceUrl = URL(string: imageUrl)
                let imageResource = ImageResource(downloadURL: resourceUrl!, cacheKey: self.recipe.image)
            
            DispatchQueue.main.async {
                self.recipeImageView.kf.setImage(with: imageResource, placeholder: nil, options: nil, progressBlock: nil) { result in
                    switch result {
                        case .success( _) :
                            self.recipeImageView.hideSkeleton()
                    case .failure( _):
                            self.recipeImageView.hideSkeleton()
                    }
                }
            }
        } else {
            self.recipeImageView.hideSkeleton()
        }
        
        // Setting Basic Info
        self.recipeTitleLabel.text = self.recipe.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.recipePriceLabel.text = "$" + recipe.pricePerServing!.description
        self.recipeTimeLabel.text = "⌚︎" + String(recipe.readyInMinutes!) + "'"
        
        // Getting the information removing html tags - The content was intended to be presented on HTML
        do {
            try self.summaryLabel.text = self.recipe.summary?.htmlToPlainText()
        } catch {
            self.summaryLabel.text = "No Summary information yet."
        }
        
        if self.recipe.analyzedInstructions!.count > 0 {
            self.instructionsContentLabel.text = getRecipeInstructionText()
        } else {
            self.instructionsContentLabel.text = "No Instructions registered yet."
        }
    }
    
    func getRecipeInstructionText() -> String {
        
        var instructionText = ""
        
        for instruction in self.recipe.analyzedInstructions! {
            for step in instruction.steps! {
                instructionText += String(step.number!) + ". " + step.step! + "\n\n"
            }
        }
        
        return instructionText
    }
    
    @IBAction func addRecipeButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewIngredientsButtonAction(_ sender: Any) {
        
        let ingredientsVC = self.storyboard?.instantiateViewController(withIdentifier: "IngredientsTableViewController") as! IngredientsTableViewController
        
        self.navigationController?.pushViewController(ingredientsVC, animated: true)
    }
    /*
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
     */

}
/*
extension String {
    
    func htmlAttributedString(size: CGFloat) -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: -apple-system;
                font-size: \(size)px;
              }
            </style>
          </head>
          <body>
            
            \(self)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
            ) else {
            return nil
        }

        return attributedString
    }
}
*/

extension String {
    func htmlToPlainText() throws -> String?  {
        if isEmpty {
            return nil
        }
        
        if let data = data(using: .utf8) {
            let attributedString = try NSAttributedString(data: data,
                                                          options: [.documentType : NSAttributedString.DocumentType.html,
                                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            return attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return nil
    }
}
