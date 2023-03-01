//
//  RecipeManager.swift
//  RecipeBookChallenge
//
//  Created by user on 1.03.23.
//

import Foundation

protocol RecipeManagerDelegate {
    func didRecipe (recipeManager: RecipeManager, recipe: RecipeModel)
}

struct RecipeManager {
    
    
    var delegate: RecipeManagerDelegate?
    
    func fetchRecipe() {
        let url = "https://api.spoonacular.com/recipes/71642/ingredientWidget.json?apiKey=fc647a0143de42fb86cb50986d620f4c"
        getPerform(url: url)
    }
    
    
    func getPerform(url: String) {
        if let url1 = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url1) { data, response, error in
                if error != nil {
                    print("error")
                }
                if let safeData = data {
                    let recipe = parserJson(recipeData: safeData)
                    delegate?.didRecipe(recipeManager: self, recipe: recipe!)
                }
            }
            task.resume()
        }
        
        
    }
    
    func parserJson (recipeData: Data) -> RecipeModel? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(RecipeModelDecoder.self, from: recipeData)
            var ingridientsName = [String]()
            var ingridientsAmount = [String]()
            for i in decoderData.ingredients {
                ingridientsName.append(i.name)
                ingridientsAmount.append("\(i.amount.metric.value) \(i.amount.metric.unit) ")
            }
            let recipe = RecipeModel(ingridientName: ingridientsName, ingridiendAmount: ingridientsAmount)
            return recipe
        } catch {
          print("error1")
            return nil
        }
    }
    
}
