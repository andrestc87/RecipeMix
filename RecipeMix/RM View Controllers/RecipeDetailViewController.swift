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
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("DETAIL WITH RECIPE")
    }
    

    @IBAction func saveRecipeAction(_ sender: Any) {
        
        if !isRecipeAlreadyRegistered() {
            let recipe = RM_Recipe(context: DataController.shared.viewContext)
            
            if (self.recipe.aggregateLikes != nil) {
                recipe.aggregateLikes = Int64(self.recipe.aggregateLikes!)
            }
            recipe.cheap = self.recipe.cheap!
            recipe.creditsText = self.recipe.creditsText!
            recipe.dairyFree = self.recipe.dairyFree!
            recipe.gaps = self.recipe.gaps!
            recipe.glutenFree = self.recipe.glutenFree!
            recipe.healthScore = NSDecimalNumber(value: self.recipe.healthScore!)
            if (self.recipe.id != nil) {
                recipe.id = Int64(self.recipe.id!)
            }
            recipe.image = self.recipe.image!
            recipe.imageType = self.recipe.imageType!
            recipe.instructions = self.recipe.instructions!
            recipe.license = self.recipe.license!
            recipe.lowFodmap = self.recipe.lowFodmap!
            if (self.recipe.originalId != nil) {
                recipe.originalId = Int64(self.recipe.originalId!)
            }
            recipe.pricePerServing = NSDecimalNumber(value: self.recipe.pricePerServing!)
            if (self.recipe.readyInMinutes != nil) {
                recipe.readyInMinutes = Int64(self.recipe.readyInMinutes!)
            }
            recipe.registeredDate = Date()
            if (self.recipe.servings != nil) {
                recipe.servings = Int64(self.recipe.servings!)
            }
            recipe.sourceName = self.recipe.sourceName!
            recipe.sourceUrl = self.recipe.sourceUrl!
            recipe.spoonacularScore = self.recipe.spoonacularScore!
            recipe.spoonacularSourceUrl = self.recipe.spoonacularSourceUrl!
            recipe.summary = self.recipe.summary!
            recipe.sustainable = self.recipe.sustainable!
            recipe.title = self.recipe.title!
            recipe.vegan = self.recipe.vegan!
            recipe.vegetarian = self.recipe.vegetarian!
            recipe.veryHealthy = self.recipe.veryHealthy!
            recipe.veryPopular = self.recipe.veryPopular!
            if (self.recipe.weightWatcherSmartPoints != nil) {
                recipe.weightWatcherSmartPoints = Int64(self.recipe.weightWatcherSmartPoints!)
            }
            if (self.recipe.cuisines!.count > 0) {
                for cuisine in self.recipe.cuisines!{
                    let cuisineToSave = RM_Cuisines(context: DataController.shared.viewContext)
                    cuisineToSave.recipe = recipe
                    cuisineToSave.cuisineDescription = cuisine
                }
            }
            
            if (self.recipe.diets!.count > 0) {
                for diet in self.recipe.diets!{
                    let dietToSave = RM_Diets(context: DataController.shared.viewContext)
                    dietToSave.recipe = recipe
                    dietToSave.dietsDescription = diet
                }
            }
            
            if (self.recipe.dishTypes!.count > 0) {
                for dishType in self.recipe.dishTypes!{
                    let dishTypeToSave = RM_DishTypes(context: DataController.shared.viewContext)
                    dishTypeToSave.recipe = recipe
                    dishTypeToSave.dishTypeDescription = dishType
                }
            }
            
            if (self.recipe.occasions!.count > 0) {
                for occasion in self.recipe.occasions!{
                    let occasionToSave = RM_Occasions(context: DataController.shared.viewContext)
                    occasionToSave.recipe = recipe
                    occasionToSave.occasionDescription = occasion
                }
            }
            
            if (self.recipe.analyzedInstructions!.count > 0) {
                // Instruction
                for instruction in self.recipe.analyzedInstructions! {
                    let analyzedInstructionToSave = RM_AnalizedInstructions(context: DataController.shared.viewContext)
                    analyzedInstructionToSave.name = instruction.name
                    analyzedInstructionToSave.recipe = recipe
                    //Step
                    for step in instruction.steps! {
                        let stepToSave = RM_Steps(context: DataController.shared.viewContext)
                        if (step.number != nil) {
                            stepToSave.number = Int64(step.number!)
                        }
                        stepToSave.step = step.step
                        stepToSave.analizedInstructions = analyzedInstructionToSave
                        //Ingredients
                        if (step.ingredients != nil) {
                            for ingredient in step.ingredients! {
                                let ingredientToSave = RM_Ingredients(context: DataController.shared.viewContext)
                                ingredientToSave.steps = stepToSave
                                if (ingredient.id != nil) {
                                    ingredientToSave.id = Int64(ingredient.id!)
                                }
                                ingredientToSave.image = ingredient.image
                                ingredientToSave.localizedName = ingredient.localizedName
                                ingredientToSave.name = ingredient.name
                            }
                        }
                        //Equipment
                        if (step.equipments != nil) {
                            for equipment in step.equipments! {
                                let equipmentToSave = RM_Equipment(context: DataController.shared.viewContext)
                                equipmentToSave.steps = stepToSave
                                if (equipment.id != nil) {
                                    equipmentToSave.id = Int64(equipment.id!)
                                }
                                equipmentToSave.image = equipment.image
                                equipmentToSave.localizedName = equipment.localizedName
                                equipmentToSave.name = equipment.name
                            }
                        }
                        
                        // Length
                        if step.length != nil {
                            let lengthToSave = RM_Length(context: DataController.shared.viewContext)
                            lengthToSave.steps = stepToSave
                            if (step.length?.number != nil) {
                                lengthToSave.number = Int64(step.length!.number!)
                            }
                            lengthToSave.unit = step.length?.unit
                        }
                    }
                }
                
                // Extended Ingredients
                if (self.recipe.extendedIngredients!.count > 0) {
                    for extendendIngredient in self.recipe.extendedIngredients! {
                        let extendedIngredientToSave = RM_ExtendedIngredients(context: DataController.shared.viewContext)
                        extendedIngredientToSave.recipe = recipe
                        extendedIngredientToSave.aisle = extendendIngredient.aisle
                        extendedIngredientToSave.amount = NSDecimalNumber(value: extendendIngredient.amount!)
                        extendedIngredientToSave.consistency = extendendIngredient.consistency
                        if (extendendIngredient.id != nil) {
                            extendedIngredientToSave.id = Int64(extendendIngredient.id!)
                        }
                        extendedIngredientToSave.image = extendendIngredient.image
                        extendedIngredientToSave.name = extendendIngredient.name
                        extendedIngredientToSave.original = extendendIngredient.original
                        extendedIngredientToSave.originalName = extendendIngredient.originalName
                        extendedIngredientToSave.originalString = extendendIngredient.originalString
                        extendedIngredientToSave.unit = extendendIngredient.unit
                    }
                }
                
            }
            
            
            do {
                try DataController.shared.viewContext.save()
            } catch {
                let alertController = UIAlertController(title: "Error", message: "An error occurred while adding your recipe. Please, try again alter.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            print("RECIPE SAVED")
        } else {
            let alertController = UIAlertController(title: "Error", message: "The Recipe was already added.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

    @IBAction func loadRecipesButtonAction(_ sender: Any) {
        var savedRecipes = [RM_Recipe]()
        let fetchRequest: NSFetchRequest<RM_Recipe> = RM_Recipe.fetchRequest()
        
        if let results = try? DataController.shared.viewContext.fetch(fetchRequest){
            savedRecipes = results
        }
        let recipeSaved = savedRecipes.last
        print(recipeSaved)
    }
    
    func isRecipeAlreadyRegistered() -> Bool{
        
        var savedRecipes = [RM_Recipe]()
        let fetchRequest: NSFetchRequest<RM_Recipe> = RM_Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", self.recipe.id!)
        if let results = try? DataController.shared.viewContext.fetch(fetchRequest){
            savedRecipes = results
        }
        
        return (savedRecipes.count == 1) ? true : false
    }
}
