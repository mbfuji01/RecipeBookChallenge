//
//  TableVC.swift
//  RecipeBookChallenge
//
//  Created by user on 2.03.23.
//

import UIKit

class TableViewCell: UITableViewCell {
    private lazy var toDoBool = false
    private lazy var ingridient: UILabel = {
      let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    private lazy var amountIngridient = UILabel.recipeItemLabel
    private lazy var toDoImage: UIImageView =  {
        let image = UIImageView()
        image.image = UIImage(named: "circle")
        return image
    }()
    
    func configurateCell(model:Ingredient) {
        setupCell()
        ingridient.text = model.name.capitalized
        ingridient.numberOfLines = 0
        amountIngridient.numberOfLines = 0
        amountIngridient.text = model.amountString
    }
    
    func setupCell() {
        addSubview(toDoImage)
        addSubview(ingridient)
        addSubview(amountIngridient)
        
        //MARK: Add Constraint
        ingridient.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ingridient.leadingAnchor.constraint(equalTo: toDoImage.trailingAnchor, constant: 15),
            ingridient.trailingAnchor.constraint(equalTo: amountIngridient.leadingAnchor, constant: -5),
            ingridient.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            ingridient.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            ingridient.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        amountIngridient.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountIngridient.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            amountIngridient.widthAnchor.constraint(equalToConstant: 90),
            amountIngridient.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            amountIngridient.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            amountIngridient.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        toDoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toDoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            toDoImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            toDoImage.widthAnchor.constraint(equalToConstant: 24),
            toDoImage.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func favoriteButtonTapped() {
        toDoBool.toggle()
        toDoTapped()
    }
    
    func toDoTapped() {
        if toDoBool {
            toDoImage.image = UIImage(named: "checkmark.circle")
        }else {
            toDoImage.image = UIImage(named: "circle")
        }
    }
}
