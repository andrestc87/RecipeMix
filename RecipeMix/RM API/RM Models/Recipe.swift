//
//  Recipe.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/8/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]?
    
    enum CodingKeys: String, CodingKey {
        case recipes = "recipes"
    }
}

struct Recipe: Codable {
    let vegetarian: Bool?
    let vegan: Bool?
    let glutenFree: Bool?
    let dairyFree: Bool?
    let veryHealthy: Bool?
    let cheap: Bool?
    let veryPopular: Bool?
    let sustainable: Bool?
    let weightWatcherSmartPoints: Int?
    let gaps: String?
    let lowFodmap: Bool?
    let aggregateLikes: Int?
    let spoonacularScore: Double?
    let healthScore: Double?
    let creditsText: String?
    let license: String?
    let sourceName: String?
    let pricePerServing: Double?
    let extendedIngredients: [ExtendedIngredients]?
    let id: Int?
    let title: String?
    let readyInMinutes: Int?
    let servings: Int?
    let sourceUrl: String?
    let image: String?
    let imageType: String?
    let summary: String?
    let cuisines: [String]?
    let dishTypes: [String]?
    let diets: [String]?
    let occasions: [String]?
    let winePairing: WinePairing?
    let instructions: String?
    let analyzedInstructions: [Instruction]?
    let originalId: Int?
    let spoonacularSourceUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case vegetarian = "vegetarian"
        case vegan = "vegan"
        case glutenFree = "glutenFree"
        case dairyFree = "dairyFree"
        case veryHealthy = "veryHealthy"
        case cheap = "cheap"
        case veryPopular = "veryPopular"
        case sustainable = "sustainable"
        case weightWatcherSmartPoints = "weightWatcherSmartPoints"
        case gaps = "gaps"
        case lowFodmap = "lowFodmap"
        case aggregateLikes = "aggregateLikes"
        case spoonacularScore = "spoonacularScore"
        case healthScore = "healthScore"
        case creditsText = "creditsText"
        case license = "license"
        case sourceName = "sourceName"
        case pricePerServing = "pricePerServing"
        case extendedIngredients = "extendedIngredients"
        case id = "id"
        case title = "title"
        case readyInMinutes = "readyInMinutes"
        case servings = "servings"
        case sourceUrl = "sourceUrl"
        case image = "image"
        case imageType = "imageType"
        case summary = "summary"
        case cuisines = "cuisines"
        case dishTypes = "dishTypes"
        case diets = "diets"
        case occasions = "occasions"
        case winePairing = "winePairing"
        case instructions = "instructions"
        case analyzedInstructions = "analyzedInstructions"
        case originalId = "originalId"
        case spoonacularSourceUrl = "spoonacularSourceUrl"
    }
}

// Ingredients
struct ExtendedIngredients: Codable {
    let id: Int?
    let aisle: String?
    let image: String?
    let consistency: String?
    let name: String?
    let original: String?
    let originalString: String?
    let originalName: String?
    let amount: Double?
    let unit: String?
    let meta: [String]?
    let metaInformation: [String]?
    let measures: Measure?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case aisle = "aisle"
        case image = "image"
        case consistency = "consistency"
        case name = "name"
        case original = "original"
        case originalString = "originalString"
        case originalName = "originalName"
        case amount = "amount"
        case unit = "unit"
        case meta = "meta"
        case metaInformation = "metaInformation"
        case measures = "measures"
    }
    
}

struct Measure: Codable {
    let us: MeasureUnit?
    let metric: MeasureUnit?
    
    enum CodingKeys: String, CodingKey {
        case us = "us"
        case metric = "metric"
    }
}

struct MeasureUnit: Codable {
    let amount: Double?
    let unitShort: String?
    let unitLong: String?
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case unitShort = "unitShort"
        case unitLong = "unitLong"
    }
}

// WinePairing
struct WinePairing: Codable {
    let pairedWines: [String]?
    let pairingText: String?
    let productMatches: [ProductMatch]?
    
    enum CodingKeys: String, CodingKey {
        case pairedWines = "pairedWines"
        case pairingText = "pairingText"
        case productMatches = "productMatches"
    }
}

struct ProductMatch: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let price: String?
    let imageUrl: String?
    let averageRating: Double?
    let ratingCount: Double?
    let score: Double?
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case price = "price"
        case imageUrl = "imageUrl"
        case averageRating = "averageRating"
        case ratingCount = "ratingCount"
        case score = "score"
        case link = "link"
    }
}

// Instruction
struct Instruction: Codable {
    let name: String?
    let steps: [Step]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case steps = "steps"
    }
}

struct Step: Codable {
    let number: Int?
    let step: String?
    let ingredients: [Ingredient]?
    let equipment: [Equipment]?
    let length: Length?
    
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case step = "step"
        case ingredients = "ingredients"
        case equipment = "equipment"
        case length = "length"
    }
}

struct Ingredient: Codable {
    let id: Int?
    let name: String?
    let localizedName: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case localizedName = "localizedName"
        case image = "image"
    }
}

struct Equipment: Codable {
    let id: Int?
    let name: String?
    let localizedName: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case localizedName = "localizedName"
        case image = "image"
    }
}

struct Length: Codable {
    let number: Int?
    let unit: String?
    
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case unit = "unit"
    }
}
