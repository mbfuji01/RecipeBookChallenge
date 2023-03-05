//
//  APIService.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 21.02.2023.
//

//"https://api.spoonacular.com/recipes/complexSearch?apiKey=39e9591ac1334476a6663cf291b70458"

protocol APIServiceProtocol {
    func fetchTrendssAsync() async throws -> RecipesResponseModel
    func fetchDetailAsync(id: Int) async throws -> DetailResponseModel
    func fetchByCategoriesAsync(with categoryName: String) async throws -> RecipesResponseModel
    func fetchIngridientsAsync(id:Int) async throws -> RecipeModel
}

final class APIService {

    enum url {
        static let cookMainUrl = "https://api.spoonacular.com/recipes/"
    }
    
    enum apiKey {
        static let keyCooking = "39e9591ac1334476a6663cf291b70458"
        static let keyCooking2 = "145f438b739946ec96b50e01810525c8"
        static let keyCooking3 = "61e92e7bbdf0488bba7da727485eed79"
        static let keyCooking4 = "145f438b739946ec96b50e01810525c8"
    }
    
    enum adds {
        static let complexSearch = "complexSearch"
        static let popularity = "&sort=popularity"
        static let information = "/information"
        static let mealTypes = "&type"
        static let ingridientWidget = "/ingredientWidget.json"
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
        let urlString = "\(url.cookMainUrl)\(adds.complexSearch)?apiKey=\(apiKey.keyCooking2)\(adds.popularity)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchDetailAsync(id: Int) async throws -> DetailResponseModel {
        let urlString = "\(url.cookMainUrl)\(id)\(adds.information)?apiKey=\(apiKey.keyCooking2)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchByCategoriesAsync(with categoryName: String) async throws -> RecipesResponseModel {
        let urlString = "\(url.cookMainUrl)\(adds.complexSearch)?apiKey=\(apiKey.keyCooking2)\(adds.mealTypes)=\(categoryName)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchIngridientsAsync(id:Int) async throws -> RecipeModel {
        let urlString = "\(url.cookMainUrl)\(id)\(adds.ingridientWidget)?apiKey=\(apiKey.keyCooking2)"
        print(urlString)
        return try await networkManager.request(urlString: urlString)
    }
}


//https://api.spoonacular.com/recipes/complexSearch?apiKey=5645a96a39764c9991bbb903e6000858&type=salad

