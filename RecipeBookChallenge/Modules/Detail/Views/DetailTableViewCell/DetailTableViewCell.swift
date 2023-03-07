//
//  DetailTableViewCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 06.03.2023.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {

    private let ingredientLabel = make(UILabel()) {
        $0.text = "Apples"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let valueIngredientLabel = make(UILabel()) {
        $0.text = "5"
        $0.textColor = .black
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: IngredientsArray) {
        ingredientLabel.text = model.nameClean
        valueIngredientLabel.text = "\(model.amount.doubleToString()) \(model.unit)"
    }
    
    @objc
    private func didTapMoreButton() {
        print(#function)
    }
    
    @objc
    private func didTapbookmarkButton() {
        print(#function)
    }
}

private extension DetailTableViewCell {
    func setupCell() {
        myAddSubView(ingredientLabel)
        myAddSubView(valueIngredientLabel)
        
        NSLayoutConstraint.activate([
            ingredientLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ingredientLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            valueIngredientLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueIngredientLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

