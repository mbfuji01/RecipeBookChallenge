//
//  MainViewController.swift
//  RecipeBookChallenge
//
//  Created by demasek on 26.02.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let scrollView = make(UIScrollView()) {
        $0.backgroundColor = .clear
    }
    
    private let backgroundView = make(UIView()) {
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = make(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.text = "Get amazing recipes for cooking"
    }
    
    private lazy var searchBar = make(UISearchBar()) {
        $0.placeholder = "Search recipes"
    }
    
    private let trendLabel = make(UILabel()) {
        $0.text = "Trending now 🔥"
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapSeeAllButton), for: .touchUpInside)
        button.setTitle("See all", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.tintColor = .red
        return button
    }()
    
    private let trendStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let popularCategoryLabel = make(UILabel()) {
        $0.text = "Popular category "
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private let recentLabel = make(UILabel()) {
        $0.text = "Recent recipe"
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private lazy var seeAllrecentButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapSeeAllrecentButton), for: .touchUpInside)
        button.setTitle("See all", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.tintColor = .red
        return button
    }()
    
    private let recentStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let popularCreatorsLabel = make(UILabel()) {
        $0.text = "Popular creators"
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private lazy var seeAllpopularCreatorsButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapSeeAllpopularCreatorsButton), for: .touchUpInside)
        button.setTitle("See all", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.tintColor = .red
        return button
    }()
    
    private let popularCreatorsStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let mainStackView = make(UIStackView()) {
        $0.spacing = 10
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let trendView = TrendView()
    
    private lazy var popularCategoryView = make(PopularCategoryView()) {
        $0.delegate = self
    }
    
    private let categoryItemView = CategoryItemView()
    private let recentView = RecentView()
    private let popularCreatorView = PopularCreatorView()
    
    private let mainBrain = MainBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    @objc
    private func didTapSeeAllButton() {
        print(#function)
    }
    
    @objc
    private func didTapSeeAllrecentButton() {
        print(#function)
    }
    
    @objc
    private func didTapSeeAllpopularCreatorsButton() {
        print(#function)
    }
}

extension MainViewController: PopularCategoryViewDelegate {
    func didTapCell(at index: Int) {
        var models = mainBrain.models
        models.enumerated().forEach { modelIndex, modelValue in
            if modelIndex == index {
                models[modelIndex].isSelected = true
            } else {
                models[modelIndex].isSelected = false
            }
        }
        
        let viewModel = models.map {
            CategoryCellViewModel(title: $0.title, isSelected: $0.isSelected)
        }
        popularCategoryView.configureCollectionView(with: viewModel)
    }
}

private extension MainViewController {
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        trendStackView.addArrangedSubview(trendLabel)
        trendStackView.addArrangedSubview(seeAllButton)
        
        recentStackView.addArrangedSubview(recentLabel)
        recentStackView.addArrangedSubview(seeAllrecentButton)
        
        popularCreatorsStackView.addArrangedSubview(popularCreatorsLabel)
        popularCreatorsStackView.addArrangedSubview(seeAllpopularCreatorsButton)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(searchBar)
        mainStackView.addArrangedSubview(trendStackView)
        mainStackView.addArrangedSubview(trendView)
        mainStackView.addArrangedSubview(popularCategoryLabel)
        mainStackView.addArrangedSubview(popularCategoryView)
        mainStackView.addArrangedSubview(categoryItemView)
        mainStackView.addArrangedSubview(recentStackView)
        mainStackView.addArrangedSubview(recentView)
        mainStackView.addArrangedSubview(popularCreatorsStackView)
        mainStackView.addArrangedSubview(popularCreatorView)
        
        view.myAddSubView(scrollView)
        scrollView.myAddSubView(backgroundView)
        backgroundView.myAddSubView(mainStackView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            mainStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            
            trendView.heightAnchor.constraint(equalToConstant: 298),
            categoryItemView.heightAnchor.constraint(equalToConstant: 251),
            recentView.heightAnchor.constraint(equalToConstant: 230),
            popularCreatorView.heightAnchor.constraint(equalToConstant: 150),
            seeAllButton.widthAnchor.constraint(equalToConstant: 65),
            seeAllrecentButton.widthAnchor.constraint(equalToConstant: 65),
            seeAllpopularCreatorsButton.widthAnchor.constraint(equalToConstant: 65)
        ])
    }
}

