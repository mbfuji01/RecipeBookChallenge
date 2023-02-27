//
//  MainBrain.swift
//  CookBook
//
//  Created by Сергей Золотухин on 27.02.2023.
//

final class MainBrain {
    
    var models: [CategoryCellViewModel] = [
        .init(title: "Salad", isSelected: true),
        .init(title: "Breakfast", isSelected: false),
        .init(title: "Appetizer", isSelected: false),
        .init(title: "Noodle", isSelected: false),
        .init(title: "Dinner", isSelected: false),
        .init(title: "Soups", isSelected: false)
    ]
    
}
