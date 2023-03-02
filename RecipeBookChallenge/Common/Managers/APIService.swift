//
//  APIService.swift
//  ByteCoin
//
//  Created by Сергей Золотухин on 21.02.2023.
//

//"https://api.spoonacular.com/recipes/complexSearch?apiKey=39e9591ac1334476a6663cf291b70458"

protocol APIServiceProtocol {
    func fetchTrendssAsync() async throws -> TrendResponseModel
    func fetchDetailForTrendsAsync(id: Int) async throws -> DetailResponseModel
}

final class APIService {

    enum url {
        static let cookMainUrl = "https://api.spoonacular.com/recipes/"
    }
    
    enum apiKey {
        static let keyCooking = "39e9591ac1334476a6663cf291b70458"
        static let keyCooking2 = "5645a96a39764c9991bbb903e6000858"
        static let keyCooking3 = "61e92e7bbdf0488bba7da727485eed79"
    }
    
    enum adds {
        static let complexSearch = "complexSearch"
        static let popularity = "&sort=popularity"
        static let information = "/information"
    }
    
    private let networkManager: NetworkManagerProtocol
    
    init(
        networkManager: NetworkManagerProtocol
    ) {
        self.networkManager = networkManager
    }
}

extension APIService: APIServiceProtocol {

    func fetchTrendssAsync() async throws -> TrendResponseModel {
        let urlString = "\(url.cookMainUrl)\(adds.complexSearch)?apiKey=\(apiKey.keyCooking3)\(adds.popularity)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchDetailForTrendsAsync(id: Int) async throws -> DetailResponseModel {
        let urlString = "\(url.cookMainUrl)\(id)\(adds.information)?apiKey=\(apiKey.keyCooking3)"
        return try await networkManager.request(urlString: urlString)
    }
}
