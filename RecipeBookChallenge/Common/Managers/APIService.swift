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
    func fetchSearch(with stringRequest: String) async throws -> [SearchModel]
}

final class APIService {
    enum url {
        static let cookMainUrl = "https://api.spoonacular.com/recipes/"
        static let searchUrl = "https://api.spoonacular.com/recipes/autocomplete"
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
        static let keyCooking9 = "9702e69019114eeeb0591169b55c9062"
		static let keyCooking10 = "2a73f68ec35b4d46b239cf06f54b766a"
		static let keyCooking11 = "2043207d708f404fbdbe0216f2bb7e5f"
    }
    
    let apiKeySelect = apiKey.keyCooking10
    
    enum adds {
        static let complexSearch = "complexSearch"
        static let popularity = "&sort=popularity"
        static let information = "/information?includeNutrition=true"
        static let mealTypes = "&type"
        static let ingridientWidget = "/ingredientWidget.json"
        static let manyIds = "informationBulk?ids="
        static let moreInfo = "/card"
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
        let reworkedString = categoryName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(url.cookMainUrl)\(adds.complexSearch)?apiKey=\(apiKeySelect)\(adds.mealTypes)=\(reworkedString)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetcManyIdsAsync(with stringIds: String) async throws -> [DetailResponseModel] {
        let urlString = "\(url.cookMainUrl)\(adds.manyIds)\(stringIds)&apiKey=\(apiKeySelect)"
        print(urlString)
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchSearch(with stringRequest: String) async throws -> [SearchModel] {
        let reworkedString = stringRequest.replacingOccurrences(of: " ", with: "")
        print(reworkedString)
        let urlString = "\(url.searchUrl)?query=\(reworkedString)&number=20&apiKey=\(apiKeySelect)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchMoreInfo(id: Int) async throws -> DetailResponseModel {
        let urlString = "\(url.cookMainUrl)\(id)\(adds.moreInfo)?apiKey=\(apiKeySelect)"
        return try await networkManager.request(urlString: urlString)
    }
}

//https://api.spoonacular.com/recipes/autocomplete?apiKey=9702e69019114eeeb0591169b55c9062&query=apple&number=25

//https://api.spoonacular.com/recipes/complexSearch?apiKey=39e9591ac1334476a6663cf291b70458&type=salad

//https://api.spoonacular.com/recipes/informationBulk?ids=715449&apiKey=611a18c719a04c4fb245e60ee70336b3

//https://api.spoonacular.com/recipes/715449/information?includeNutrition=true&apiKey=62d923412e0a409cab1961242371c4d1


//https://api.spoonacular.com/recipes/715449/nutritionLabel?apiKey=50277d5ec39d40019e9bdb57e9afe6a6
