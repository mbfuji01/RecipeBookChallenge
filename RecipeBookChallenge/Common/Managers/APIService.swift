//
//  APIService.swift
//  ByteCoin
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
        static let keyCooking = "39e9591ac1334476a6663cf291b70458"
        static let keyCooking2 = "5645a96a39764c9991bbb903e6000858"
        static let keyCooking3 = "61e92e7bbdf0488bba7da727485eed79"
        static let keyCooking4 = "145f438b739946ec96b50e01810525c8"
    }
    
    enum adds {
        static let complexSearch = "complexSearch"
        static let popularity = "&sort=popularity"
        static let information = "/information"
        static let mealTypes = "&type"
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
        let urlString = "\(url.cookMainUrl)\(adds.complexSearch)?apiKey=\(apiKey.keyCooking3)\(adds.popularity)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchDetailAsync(id: Int) async throws -> DetailResponseModel {
        let urlString = "\(url.cookMainUrl)\(id)\(adds.information)?apiKey=\(apiKey.keyCooking3)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchByCategoriesAsync(with categoryName: String) async throws -> RecipesResponseModel {
        let urlString = "\(url.cookMainUrl)\(adds.complexSearch)?apiKey=\(apiKey.keyCooking3)\(adds.mealTypes)=\(categoryName)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetcManyIdsAsync(with stringIds: String) async throws -> [DetailResponseModel] {
        let urlString = "\(url.cookMainUrl)\(adds.manyIds)\(stringIds)&apiKey=\(apiKey.keyCooking3)"
        return try await networkManager.request(urlString: urlString)
    }
}

//https://api.spoonacular.com/recipes/complexSearch?apiKey=39e9591ac1334476a6663cf291b70458&type=salad
//https://api.spoonacular.com/recipes/informationBulk?ids=715538,716429&apiKey=5645a96a39764c9991bbb903e6000858
