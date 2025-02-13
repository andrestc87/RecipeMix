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

class RecipeViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
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
    var recipeId: Int!
    var savedRecipe: RM_Recipe!
    var apiUtils = RecipeMixAPIUtils()
    var isRecipeSaved: Bool = false
    var defaultButtonColor: CGColor!
    var comesFromDashboard = Bool()
    var fetchedResultsController: NSFetchedResultsController<RM_ExtendedIngredients>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recipe"
        self.navigationItem.largeTitleDisplayMode = .never
        self.defaultButtonColor = self.addRecipeButton.layer.backgroundColor
        
        // Use this validation to determine if the information is going to be from the dashboard or from the data stored on the device
        self.isRecipeSaved = apiUtils.validateExistingRecipe(recipeId: self.recipeId)
        if self.isRecipeSaved {
            self.savedRecipe = self.apiUtils.getRecipeById(recipeId: self.recipeId)
        }
        
        if isRecipeSaved && !comesFromDashboard {
            setupSavedRecipeContent()
        } else {
            setupRecipeContent()
        }
    }
    
    func setupRecipeContent() {
        //Updates the add recipe button
        updateRecipeButton()
        
        //Recipe Image View
        setupRecipeImage(image: self.recipe.image!)
        
        setupRecipeBasicInformation(title: self.recipe.title!, price: self.recipe.pricePerServing!, minutes: self.recipe.readyInMinutes!, summary: self.recipe.summary!)
        
        //Setup the instructions
        if self.recipe.analyzedInstructions!.count > 0 {
            self.instructionsContentLabel.text = getRecipeInstructionText()
        } else {
            self.instructionsContentLabel.text = "No Instructions registered yet."
        }
    }
    
    func setupSavedRecipeContent() {
        //Updates the add recipe button
        updateRecipeButton()
        
        //Recipe Image View
        setupRecipeImage(image: self.savedRecipe.image!)
        
        //Setup Basic Information
        setupRecipeBasicInformation(title: self.savedRecipe.title!, price: self.savedRecipe.pricePerServing!.doubleValue, minutes: Int(self.savedRecipe.readyInMinutes), summary: self.savedRecipe.summary!)
        
        //Setup the instructions
        if self.savedRecipe.instructions!.count > 0 {
            self.instructionsContentLabel.text = self.savedRecipe.instructions
        } else {
            self.instructionsContentLabel.text = "No Instructions registered yet."
        }
    }
    
    func setupRecipeImage(image: String) {
        //Recipe Image View
        self.recipeImageView.showAnimatedGradientSkeleton()
        // Using Kingsfire to load images
        if image.count > 0 {
            let resourceUrl = URL(string: image)
            let imageResource = ImageResource(downloadURL: resourceUrl!, cacheKey: image)
            
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
    }
    
    func setupRecipeBasicInformation(title: String, price: Double, minutes: Int, summary: String) {
        self.recipeTitleLabel.text = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.recipePriceLabel.text = "$" + String(format: "%.2f", price)
        self.recipeTimeLabel.text = "⌚︎" + String(minutes) + "'"
        
        // Getting the information removing html tags - The content was intended to be presented on HTML
        do {
            try self.summaryLabel.text = summary.htmlToPlainText()
        } catch {
            self.summaryLabel.text = "No Summary information yet."
        }
    }
    
    func updateRecipeButton() {
        if !self.isRecipeSaved {
            self.addRecipeButton.setTitle("Add to My Recipes", for: .normal)
            self.addRecipeButton.layer.backgroundColor = self.defaultButtonColor
        } else {
            self.addRecipeButton.setTitle("Remove from My Recipes", for: .normal)
            self.addRecipeButton.layer.backgroundColor = UIColor.red.cgColor
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
        if !self.isRecipeSaved {
            do {
                
                self.recipe.instructions = self.instructionsContentLabel.text
                try apiUtils.saveRecipe(recipeToSave: self.recipe)
                
                let alertController = UIAlertController(title: "Recipe", message: "The Recipe was registered correclty.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alertController, animated: true, completion: {
                    self.isRecipeSaved = true
                    //Display information
                    self.updateRecipeButton()
                    self.savedRecipe = self.apiUtils.getRecipeById(recipeId: self.recipe.id!)
                })
            
            } catch {
                let alertController = UIAlertController(title: "Error", message: "An error occurred while adding your recipe. Please, try again alter.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            
            let alert = UIAlertController(title: "Remove Recipe", message: "Are you sure you want to remove this Recipe from your selection?", preferredStyle: .alert)

            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] action in
                
                self?.apiUtils.deleteRecipe(recipe: (self?.savedRecipe)!)
                self?.isRecipeSaved = false
                self?.savedRecipe = nil
                self?.updateRecipeButton()
            }
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func viewIngredientsButtonAction(_ sender: Any) {
        var ingredientsArray: [String] = []
        
        
        if self.isRecipeSaved && !self.comesFromDashboard {
            ingredientsArray = getStoredRecipeIngredients(recipe: self.savedRecipe)
        } else {
            ingredientsArray = getRecipeIngredients(extendedIngredients: self.recipe.extendedIngredients!)
        }
        
        if ingredientsArray.count > 0 {
            let ingredientsVC = self.storyboard?.instantiateViewController(withIdentifier: "IngredientsViewController") as! IngredientsViewController
            
            ingredientsVC.ingredients = ingredientsArray
            ingredientsVC.savedRecipe = self.savedRecipe
            ingredientsVC.isRecipeSaved = self.isRecipeSaved
            
            self.navigationController?.pushViewController(ingredientsVC, animated: true)
            
        } else {
            let alertController = UIAlertController(title: "Info", message: "There are no ingrdients registered yet.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getRecipeIngredients(extendedIngredients: [ExtendedIngredients]) -> [String] {
        var ingredients = [String]()
        
        for ingredient in extendedIngredients {
            ingredients.append(ingredient.originalString!)
        }
        
        return ingredients
    }
    
    func getStoredRecipeIngredients(recipe: RM_Recipe) -> [String] {
        var ingredientsArray: [String] = []
        
        let fetchRequest: NSFetchRequest<RM_ExtendedIngredients> = RM_ExtendedIngredients.fetchRequest()
        let predicate = NSPredicate(format: "recipe == %@", recipe)
        
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "originalString", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:
            DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            let ingredientsCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            var ingredient = RM_ExtendedIngredients()
            
            for index in 0..<ingredientsCount {
                ingredient = fetchedResultsController.object(at: IndexPath(row: index, section: 0))
                ingredientsArray.append(ingredient.originalString!)
            }
        } catch {
            print("error performing fetch")
        }
        
        return ingredientsArray
    }
}

extension String {
    
    // Some elements from the recipe are in HTML, with this we will remove all the HTML tags
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
