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
    let readyInMinutes: Double
    let image: String
    let dishTypes: [String]
    let cookingMinutes: Int
    let servings: Int
}

struct DetailModel {
    let aggregateLikes: Int
    let id: Int
    let title: String
    let readyInMinutes: Double
    let image: String
    let dishTypes: [String]
    
    var dishTypeString: String {
        return String(format: "%0.1f")
    }
}
