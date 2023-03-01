//
//  RecipeCollectionViewCell.swift
//  RecipeBookChallenge
//
//  Created by demasek on 01.03.2023.
//

import Foundation
import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
	
	//MARK: - Create UI
	
	private lazy var ingredientsNameLabel = UILabel.recipeItemLabel
	private lazy var amountLabel = UILabel.recipeItemLabel
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		backgroundColor = .white
		ingredientsNameLabel.text = "Sugar"
		amountLabel.text = "280g"
		addSubview(ingredientsNameLabel)
		addSubview(amountLabel)
	}
	
	private func setConstraints() {
		ingredientsNameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			ingredientsNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
			ingredientsNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
		amountLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
			amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}
