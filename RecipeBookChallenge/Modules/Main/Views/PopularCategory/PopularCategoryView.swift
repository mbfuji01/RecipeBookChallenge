//
//  PopularCategoryView.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 27.02.2023.
//

import UIKit

protocol PopularCategoryViewDelegate: AnyObject {
    func didTapCell(at index: Int)
}
 
final class PopularCategoryView: UIView {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: 84, height: 33)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        return collectionView
    }()
    
    private var categories: [CategoryCellViewModel] = [
        .init(title: "Salad", isSelected: true),
        .init(title: "Breakfast", isSelected: false),
        .init(title: "Appetizer", isSelected: false),
        .init(title: "Noodle", isSelected: false),
        .init(title: "Dinner", isSelected: false),
        .init(title: "Soups", isSelected: false)
    ]
    
    weak var delegate: PopularCategoryViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCollectionView(with viewModel: [CategoryCellViewModel]) {
        categories = viewModel
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource Impl

extension PopularCategoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell()
        }
        cell.configureCell(with: categories[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate Impl

extension PopularCategoryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item)")
        delegate?.didTapCell(at: indexPath.item)
    }
}

// MARK: - Private methods

private extension PopularCategoryView {
    func setupView() {
        backgroundColor = .clear
        addSubviews()
        setConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func addSubviews() {
        myAddSubView(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
}

