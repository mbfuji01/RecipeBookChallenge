import Foundation

// MARK: - Recep
struct RecipeModelDecoder: Decodable {
        let ingredients: [Ingredient]
    }

    // MARK: - Ingredient
    struct Ingredient: Decodable {
        let name, image: String
        let amount: Amount
    }

    // MARK: - Amount
    struct Amount: Decodable {
        let metric, us:Metric
    }

    // MARK: - Metric
    struct Metric: Decodable {
        let value: Double
        let unit: String
    }

