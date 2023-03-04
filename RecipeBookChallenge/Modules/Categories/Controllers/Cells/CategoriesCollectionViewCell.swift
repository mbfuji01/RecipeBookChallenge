//
//  CategoriesCollectionViewCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 03.03.2023.
//

import UIKit

final class CategoriesCollectionViewCell: UICollectionViewCell {
    
    private let mainImageView = make(UIImageView()) {
        $0.image = UIImage(named: "recentImage")
    }
    
    private let descriptionLabel = make(UILabel()) {
        $0.text = "Kelewele Ghanian Recipe"
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configureCell(with categoryTitle: String, with image: String) {
    func configureCell(with image: String) {
//        descriptionLabel.text = categoryTitle
        mainImageView.downloaded(from: image)
    }
}

private extension CategoriesCollectionViewCell {
    func setupCell() {
        
        contentView.myAddSubView(mainImageView)
        contentView.myAddSubView(descriptionLabel)
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -10)
        ])
    }
}
