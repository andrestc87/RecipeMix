//
//  RecipeMixAPIUtils.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/19/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecipeMixAPIUtils {
    
    // Saves the Recipe in Core Data
    func saveRecipe(recipeToSave: Recipe) throws {
        let recipe = RM_Recipe(context: DataController.shared.viewContext)
        
        if (recipeToSave.aggregateLikes != nil) {
            recipe.aggregateLikes = Int64(recipeToSave.aggregateLikes!)
        }
        recipe.cheap = recipeToSave.cheap!
        recipe.creditsText = recipeToSave.creditsText!
        recipe.dairyFree = recipeToSave.dairyFree!
        recipe.gaps = recipeToSave.gaps!
        recipe.glutenFree = recipeToSave.glutenFree!
        recipe.healthScore = NSDecimalNumber(value: recipeToSave.healthScore!)
        if (recipeToSave.id != nil) {
            recipe.id = Int64(recipeToSave.id!)
        }
        recipe.image = recipeToSave.image!
        recipe.imageType = recipeToSave.imageType!
        recipe.instructions = recipeToSave.instructions!
        recipe.license = recipeToSave.license!
        recipe.lowFodmap = recipeToSave.lowFodmap!
        if (recipeToSave.originalId != nil) {
            recipe.originalId = Int64(recipeToSave.originalId!)
        }
        recipe.pricePerServing = NSDecimalNumber(value: recipeToSave.pricePerServing!)
        if (recipeToSave.readyInMinutes != nil) {
            recipe.readyInMinutes = Int64(recipeToSave.readyInMinutes!)
        }
        recipe.registeredDate = Date()
        if (recipeToSave.servings != nil) {
            recipe.servings = Int64(recipeToSave.servings!)
        }
        recipe.sourceName = recipeToSave.sourceName!
        recipe.sourceUrl = recipeToSave.sourceUrl!
        recipe.spoonacularScore = recipeToSave.spoonacularScore!
        recipe.spoonacularSourceUrl = recipeToSave.spoonacularSourceUrl!
        recipe.summary = recipeToSave.summary!
        recipe.sustainable = recipeToSave.sustainable!
        recipe.title = recipeToSave.title!
        recipe.vegan = recipeToSave.vegan!
        recipe.vegetarian = recipeToSave.vegetarian!
        recipe.veryHealthy = recipeToSave.veryHealthy!
        recipe.veryPopular = recipeToSave.veryPopular!
        if (recipeToSave.weightWatcherSmartPoints != nil) {
            recipe.weightWatcherSmartPoints = Int64(recipeToSave.weightWatcherSmartPoints!)
        }
        if (recipeToSave.cuisines!.count > 0) {
            for cuisine in recipeToSave.cuisines!{
                let cuisineToSave = RM_Cuisines(context: DataController.shared.viewContext)
                cuisineToSave.recipe = recipe
                cuisineToSave.cuisineDescription = cuisine
            }
        }
        
        if (recipeToSave.diets!.count > 0) {
            for diet in recipeToSave.diets!{
                let dietToSave = RM_Diets(context: DataController.shared.viewContext)
                dietToSave.recipe = recipe
                dietToSave.dietsDescription = diet
            }
        }
        
        if (recipeToSave.dishTypes!.count > 0) {
            for dishType in recipeToSave.dishTypes!{
                let dishTypeToSave = RM_DishTypes(context: DataController.shared.viewContext)
                dishTypeToSave.recipe = recipe
                dishTypeToSave.dishTypeDescription = dishType
            }
        }
        
        if (recipeToSave.occasions!.count > 0) {
            for occasion in recipeToSave.occasions!{
                let occasionToSave = RM_Occasions(context: DataController.shared.viewContext)
                occasionToSave.recipe = recipe
                occasionToSave.occasionDescription = occasion
            }
        }
        
        if (recipeToSave.analyzedInstructions!.count > 0) {
            // Instruction
            for instruction in recipeToSave.analyzedInstructions! {
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
            if (recipeToSave.extendedIngredients!.count > 0) {
                for extendendIngredient in recipeToSave.extendedIngredients! {
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
        
        try DataController.shared.viewContext.save()
    }
    
    func getSavedRecipes() -> [RM_Recipe]{
        var savedRecipes = [RM_Recipe]()
        let fetchRequest: NSFetchRequest<RM_Recipe> = RM_Recipe.fetchRequest()
        
        if let results = try? DataController.shared.viewContext.fetch(fetchRequest){
            savedRecipes = results
        }
        let lastRecipeSaved = savedRecipes.last
        print(lastRecipeSaved as Any)
        
        return savedRecipes
    }
    
    func validateExistingRecipe(recipeId: Int) -> Bool {
        var savedRecipes = [RM_Recipe]()
        let fetchRequest: NSFetchRequest<RM_Recipe> = RM_Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", recipeId)
        if let results = try? DataController.shared.viewContext.fetch(fetchRequest){
            savedRecipes = results
        }
        
        return (savedRecipes.count == 1) ? true : false
    }
    
}
