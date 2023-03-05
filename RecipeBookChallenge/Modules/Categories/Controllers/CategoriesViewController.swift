//
//  CategoriesViewController.swift
//  RecipeBookChallenge
//
//  Created by demasek on 26.02.2023.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    private let titleLabel = make(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.text = "Popular categories"
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 40) / 2, height: 110)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        return collectionView
    }()
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    private let categoryArray = CategoryArray()
    
    private var imageArray: [CategoryImageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        fetchCategoriesImages()
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapCell(at: indexPath.item)
    }
}

extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        categoryArray.categories.count
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else { fatalError("") }
        
//        let stringValue = categoryArray.categories[indexPath.item]
        let imageValue = imageArray[indexPath.item].image
        cell.configureCell(with: imageValue)

//        cell.configureCell(with: stringValue, with: imageValue)
        return cell
    }
}

private extension CategoriesViewController {
    
    func didTapCell(at index: Int) {
        
        let categoryName = categoryArray.categories[index]
        
        Task(priority: .utility) {
            do {
                let categoryRecipes = try await apiService.fetchByCategoriesAsync(with: categoryName)
                await MainActor.run(body: {
                    routeToGenlViewController(with: categoryRecipes, with: index)
                })
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
    
    func fetchCategoriesImages() {
        categoryArray.categories.enumerated().forEach { index, value in
            Task(priority: .utility) {
                do {
                    let categoryRecipes = try await apiService.fetchByCategoriesAsync(with: value)
                    await MainActor.run(body: {
                        imageArray = categoryRecipes.results.map { CategoryImageModel.init(image: $0.image)
                        }
                        collectionView.reloadData()
                    })
                } catch {
                    await MainActor.run(body: {
                        print(error, error.localizedDescription)
                    })
                }
            }
        }
    }
    
    func routeToGenlViewController(with model: RecipesResponseModel, with index: Int) {
        let viewController = GenlViewController()
//        viewController.modalPresentationStyle = .fullScreen
        viewController.setupModel(with: model)
        viewController.setupTitle(with: categoryArray.categories[index])
        present(viewController, animated: true)
    }
    
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.myAddSubView(titleLabel)
        view.myAddSubView(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
    }
}

