//
//  APIService.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 21.02.2023.
//

protocol APIServiceProtocol {
    func fetchTrendssAsync() async throws -> RecipesResponseModel
    func fetchDetailAsync(id: Int) async throws -> DetailResponseModel
    func fetchByCategoriesAsync(with categoryName: String) async throws -> RecipesResponseModel
    func fetcManyIdsAsync(with stringIds: String) async throws -> [DetailResponseModel]
}

final class APIService {
    enum url {
        static let cookMainUrl = "https://api.spoonacular.com/recipes/"
    }
    
    enum apiKey {
        static let keyCooking1 = "ecc4c1f4535c4797b5a50185f5802748"
        static let keyCooking2 = "62d923412e0a409cab1961242371c4d1"
        static let keyCooking3 = "ecc4c1f4535c4797b5a50185f5802748"
        static let keyCooking4 = "ecc4c1f4535c4797b5a50185f5802748"
        static let keyCooking5 = "613ca01b8c5e443986dc8eaa1946d5ec"
        static let keyCooking6 = "50277d5ec39d40019e9bdb57e9afe6a6"
        static let keyCooking7 = "611a18c719a04c4fb245e60ee70336b3"
        static let keyCooking8 = "39e9591ac1334476a6663cf291b70458"
    }
    
    let apiKeySelect = apiKey.keyCooking8
    
    enum adds {
        static let complexSearch = "complexSearch"
        static let popularity = "&sort=popularity"
        static let information = "/information?includeNutrition=true"
        static let mealTypes = "&type"
        static let ingridientWidget = "/ingredientWidget.json"
        static let manyIds = "informationBulk?ids="
    }
    
    private let networkManager: NetworkManagerProtocol
    
    init(
        networkManager: NetworkManagerProtocol
    ) {
        self.networkManager = networkManager
    }
}

extension APIService: APIServiceProtocol {
    func fetchTrendssAsync() async throws -> RecipesResponseModel {
        let urlString = "\(url.cookMainUrl)\(adds.complexSearch)?apiKey=\(apiKeySelect)\(adds.popularity)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchDetailAsync(id: Int) async throws -> DetailResponseModel {
        let urlString = "\(url.cookMainUrl)\(id)\(adds.information)&apiKey=\(apiKeySelect)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchByCategoriesAsync(with categoryName: String) async throws -> RecipesResponseModel {
        let urlString = "\(url.cookMainUrl)\(adds.complexSearch)?apiKey=\(apiKeySelect)\(adds.mealTypes)=\(categoryName)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetcManyIdsAsync(with stringIds: String) async throws -> [DetailResponseModel] {
        let urlString = "\(url.cookMainUrl)\(adds.manyIds)\(stringIds)&apiKey=\(apiKeySelect)"
        return try await networkManager.request(urlString: urlString)
    }
}

//https://api.spoonacular.com/recipes/complexSearch?apiKey=39e9591ac1334476a6663cf291b70458&type=salad
//https://api.spoonacular.com/recipes/informationBulk?ids=715449&apiKey=62d923412e0a409cab1961242371c4d1

//https://api.spoonacular.com/recipes/715449/ingredientWidget.json?apiKey=62d923412e0a409cab1961242371c4d1

//https://api.spoonacular.com/recipes/715449/information?includeNutrition=true&apiKey=62d923412e0a409cab1961242371c4d1
