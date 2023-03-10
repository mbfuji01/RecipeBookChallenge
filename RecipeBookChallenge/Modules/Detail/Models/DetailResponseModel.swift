//
//  File.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 02.03.2023.
//

struct DetailResponseModel: Codable {
    let aggregateLikes: Int
    let id: Int
    let title: String
    let readyInMinutes: Int
    let image: String
    let dishTypes: [String]
    let servings: Int
    let nutrition: NutritionDetails?
    let extendedIngredients: [IngredientsArray]
}

struct DetailModel: Codable {
    let aggregateLikes: Int
    let id: Int
    let title: String
    let readyInMinutes: Int
    let image: String
    let dishTypes: [String]
    let servings: Int
    let nutrition: NutritionDetails?
    let extendedIngredients: [IngredientsArray]

    var dishTypeString: String {
        return String(format: "%0.1f")
    }
}


struct NutritionDetails: Codable {
    let nutrients: [NutrientsDetails]
}

struct NutrientsDetails: Codable {
    let amount: Double
    let unit: String
}

struct IngredientsArray: Codable {
    let nameClean: String
    let amount: Double
    let unit: String
}
