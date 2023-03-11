//
//  GenlCollectionViewCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 03.03.2023.
//

import UIKit

final class GenlCollectionViewCell: UICollectionViewCell {
    
    private let mainImageView = make(UIImageView()) {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.image = UIImage(named: "placeholderImage")
    }
    
    private let rateImageView = make(UIImageView()) {
        $0.clipsToBounds = true
        $0.image = UIImage(systemName: "hand.thumbsup.fill")
        $0.tintColor = .black
    }
    
    private let rateLabel = make(UILabel()) {
        $0.text = "4,5 "
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private let rateStackView = make(UIStackView()) {
        $0.spacing = 3
        $0.distribution = .fill
        $0.alignment = .trailing
        $0.axis = .horizontal
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 7
    }

    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapbookmarkButton), for: .touchUpInside)
        button.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let durationLabel = make(UILabel()) {
        $0.text = " 2:10 "
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 7
        $0.clipsToBounds = true
    }
    
    private let descriptionLabel = make(UILabel()) {
        $0.text = "How to sharwama at home"
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "ellipsis.vertical.bubble"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let descriptionStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let mainStackView = make(UIStackView()) {
        $0.spacing = 1
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
    
    func configureCell(with model: DetailResponseModel) {
        descriptionLabel.text = model.title
        durationLabel.text = " \(Int(model.readyInMinutes)) mins "
        rateLabel.text = "\(model.aggregateLikes) "
        guard let image = model.image else { return }
        mainImageView.downloaded(from: image)
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

private extension GenlCollectionViewCell {
    func setupCell() {
        
        rateStackView.addArrangedSubview(rateImageView)
        rateStackView.addArrangedSubview(rateLabel)
        
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(moreButton)
        
        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(descriptionStackView)
        
        contentView.myAddSubView(mainStackView)
        contentView.myAddSubView(rateStackView)
        contentView.myAddSubView(bookmarkButton)
        contentView.myAddSubView(durationLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            rateStackView.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 10),
            rateStackView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor, constant: 10),
            
            bookmarkButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            
            durationLabel.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -10),
            durationLabel.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -10),
            mainImageView.heightAnchor.constraint(equalToConstant: 160),
            moreButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
