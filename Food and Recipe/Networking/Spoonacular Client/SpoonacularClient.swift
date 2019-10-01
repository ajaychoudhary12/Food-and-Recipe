//
//  SpoonacularClient.swift
//  Food and Recipe
//
//  Created by Ajay Choudhary on 26/09/19.
//  Copyright © 2019 Ajay Choudhary. All rights reserved.
//

import UIKit

class SpoonacularClient {
    static let apiKey = "a67a5241c34f45429f75c2d8a1858a67"
    
    static var url: URL {
        var components = URLComponents()
        components.host = "api.spoonacular.com"
        components.path = "/recipes/random"
        components.scheme = "https"
        
        components.queryItems = [URLQueryItem]()
        components.queryItems?.append(URLQueryItem(name: "apiKey", value: SpoonacularClient.apiKey))
        components.queryItems?.append(URLQueryItem(name: "number", value: "2"))
        
        return components.url!
    }
    
    class func getRandomRecipe(completion: @escaping ([Recipe]) -> Void) {
        let task = URLSession.shared.dataTask(with: SpoonacularClient.url) { (data, response, error) in
            guard let data = data else {
                completion([])
                return
            }
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [AnyHashable: Any]
                if let recipeArray = responseObject?["recipes"] as? [[String: Any]] {
                    let recipes = createRecipes(recipeArray: recipeArray)
                    completion(recipes)
                }
            } catch {
                print("Unable to parse the JSON data")
            }
        }
        task.resume()
        
    }
    
    class func downloadRecipeImage(imageURL: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: imageURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                completion(UIImage(data: data))
            }
            task.resume()
        }
    }
    
    private class func createRecipes(recipeArray: [[String: Any]]) -> [Recipe] {
        var recipes = [Recipe]()
        for recipeInfo in recipeArray {
            var recipe = Recipe()
            
            if let title = recipeInfo["title"] as? String {
                recipe.title = title
            }
            
            if let servings = recipeInfo["servings"] as? Int {
                recipe.servings = servings
            }
            
            if let imageURL = recipeInfo["image"] as? String {
                recipe.imageURL = imageURL
            }
            
            if let sourceURL = recipeInfo["sourceUrl"] as? String {
                recipe.sourceURL = sourceURL
            }

            if let ingredientArray = recipeInfo["extendedIngredients"] as? [[String: Any]] {
                if ingredientArray.count == 0 {
                    recipe.ingredients = []
                } else {
                    var ingredients = [String]()
                    for ingredient in ingredientArray {
                        if let ingredient = ingredient["originalString"] as? String {
                            ingredients.append(ingredient)
                        }
                    }
                    recipe.ingredients = ingredients
                }
            }
            
            if let timeRequired = recipeInfo["readyInMinutes"] as? Int {
                recipe.timeRequired = timeRequired
            }
            
            if let instructions = recipeInfo["analyzedInstructions"] as? [[String : Any]]  {
                if instructions.count == 0 {
                    recipe.instructions = []
                } else {
                    var instructionsArray = [String]()
                    for instructionSteps in instructions {
                        if let instructionSteps = instructionSteps["steps"] as? [[String : Any]] {
                            for step in instructionSteps {
                                if let instructionStep = step["step"] as? String {
                                    instructionsArray.append(instructionStep)
                                }
                            }
                        }
                    }
                    recipe.instructions = instructionsArray
                }
            }
            
            recipes.append(recipe)
        }
        return recipes
    }
    
    class func getRecipeInformation() {
        let url = URL(string: "https://api.spoonacular.com/recipes/716429/information?apiKey=\(SpoonacularClient.apiKey)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("no data found")
                return
            }
            let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
            if let instructions = responseObject?["analyzedInstructions"] as? [[String : Any]] {
                if instructions.count == 0 {
                    print("0 instructions")
                }
                for instructionSteps in instructions {
                    if let instructionSteps = instructionSteps["steps"] as? [[String : Any]] {
                        for step in instructionSteps {
                            if let instructionStep = step["step"] as? String {
                                print(instructionStep)
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
}


