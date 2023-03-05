

import Foundation


// MARK: - Recep
struct RecipeModel: Decodable {
    let ingredients: [Ingredient]
}

// MARK: - Ingredient
struct Ingredient: Decodable {
    let name, image: String
    let amount: Amount
    
    var amountString: String {
        var amountMetric = String(format: "%.0f", amount.metric.value) + " \(amount.metric.unit)"
        return amountMetric
    }
}

// MARK: - Amount
struct Amount: Decodable {
    let metric, us: Metric
}

// MARK: - Metric
struct Metric: Decodable {
    let value: Double
    let unit: String
}




