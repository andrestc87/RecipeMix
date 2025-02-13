//
//  RecipeMixClient.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/12/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

/*
 
 https://api.spoonacular.com/recipes/random?number=10&tags=chicken&apiKey=356f2955fc56448e932bb58f9c495f1d

 https://api.spoonacular.com/recipes/random?number=10&apiKey=356f2955fc56448e932bb58f9c495f1d
 */

import Foundation

class RecipeMixClient {
    
    static let recipeMixSharedInstance = RecipeMixClient()
    
    let recipeMixApiKey = "0aac219d134f4bf2b608ef2aa9dbf070"
    let recipeMixFormat = "json"
    let recipeMixBaseUrl = "https://api.spoonacular.com/recipes"
    let recipeMixRecipesPerCall = 100
    let recipeMixSearchRecipeEndpoint = "/random"
    
    func searchRecipeMixRecipes(tags: String, completion: @escaping ([Recipe]?, Error?) -> Void) {
        let searchTags = tags.lowercased()
        let searchRecipesUrl = getSearchRecipesUrl(tags: searchTags)
        
        RecipeMixClient.taskForGETRequest(url: searchRecipesUrl!, response: RecipeResponse.self) { (response, error) in
                if let response = response {
                    completion(response.recipes, nil)
                } else {
                    completion(nil, error)
                }
        }
    }
    
    func getSearchRecipesUrl(tags: String) -> URL? {
        
        let searchRecipesUrl = recipeMixBaseUrl + recipeMixSearchRecipeEndpoint
        
        guard var searchUrlComponents = URLComponents(string: searchRecipesUrl) else {
            print("Error with the base URL")
            return nil
        }
        
        // Adding all the parameters to the URL
        let number = URLQueryItem(name: "number", value: String(recipeMixRecipesPerCall))
        let tags = URLQueryItem(name: "tags", value: tags)
        let apiKey = URLQueryItem(name: "apiKey", value: recipeMixApiKey)
        
        searchUrlComponents.queryItems = [number, tags, apiKey]
        
        guard let searchUrl = searchUrlComponents.url else {
            print("Error creating search url.")
            return nil
        }
        
        return searchUrl
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void)  -> URLSessionTask{
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                
                do {
                    let errorResponse = try decoder.decode(RecipeResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse as? Error)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
        
        return task
    }
    
}

