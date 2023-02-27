//
//  CategoryItemCVCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 27.02.2023.
//

import UIKit

final class CategoryItemCVCell: UICollectionViewCell {
    
    private let mainImageView = make(UIImageView()) {
        $0.clipsToBounds = true
        $0.image = UIImage(named: "circleImage")
    }
    
    private let bgView = make(UIView()) {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 16
    }
    
    private let descriptionLabel = make(UILabel()) {
        $0.text = "Chicken and Vegetable wrap"
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private let timeLabel = make(UILabel()) {
        $0.text = "Time"
        $0.textColor = .darkGray
        $0.numberOfLines = 0
    }
    
    private let durationLabel = make(UILabel()) {
        $0.text = "5 mins"
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private let timerStackView = make(UIStackView()) {
        $0.spacing = 2
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapbookmarkButton), for: .touchUpInside)
        button.setImage(UIImage(named: "miniBookmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let bottomStackView = make(UIStackView()) {
        $0.spacing = 5
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let mainStackView = make(UIStackView()) {
        $0.spacing = 5
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {

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

private extension CategoryItemCVCell {
    func setupCell() {
        contentView.myAddSubView(bgView)
        
        timerStackView.addArrangedSubview(timeLabel)
        timerStackView.addArrangedSubview(durationLabel)

        bottomStackView.addArrangedSubview(timerStackView)
        bottomStackView.addArrangedSubview(bookmarkButton)
        
        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(bottomStackView)
        
        contentView.myAddSubView(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            mainImageView.heightAnchor.constraint(equalToConstant: 110),
            mainImageView.widthAnchor.constraint(equalToConstant: 110),
            
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30),
            
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bgView.heightAnchor.constraint(equalToConstant: 176)
        ])
    }
}
