//
//  File.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 02.03.2023.
//

struct DetailResponseModel: Decodable {
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

struct DetailModel {
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

struct NutritionDetails: Decodable {
    let nutrients: [NutrientsDetails]
}

struct NutrientsDetails: Decodable {
    let amount: Double
    let unit: String
}

struct IngredientsArray: Decodable {
    let nameClean: String
    let amount: Double
    let unit: String
}
