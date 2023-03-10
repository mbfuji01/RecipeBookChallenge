//
//  FavoriteViewController.swift
//  RecipeBookChallenge
//
//  Created by demasek on 26.02.2023.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    private let titleLabel = make(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.text = "Favorites"
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 30, height: 220)
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
        collectionView.register(GenlCollectionViewCell.self, forCellWithReuseIdentifier: "GenlCollectionViewCell")
        return collectionView
    }()
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    private var idArray: [Int] = []
    private var detailModels: [DetailResponseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupViewController()
            
            if let savedModels = loadDetailModelsFromUserDefaults() {
                detailModels = savedModels
                print("Data loaded from UserDefaults.")
            }
    }
    
    func setupGenlViewController(with model: RecipesResponseModel, with title: String) {
        titleLabel.text = title
        idArray = model.results.map { $0.id }
        configureGenlView(with: model, with: idArray)
    }
    
    func configureGenlView(with model: RecipesResponseModel, with array: [Int]) {
        Task(priority: .userInitiated) {
            let stringArray = array.map { String($0) }
            let singleString = stringArray.joined(separator: ",")
            do {
                let recipesDetail = try await apiService.fetcManyIdsAsync(with: singleString)
                detailModels = recipesDetail
                await MainActor.run(body: {
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

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeNumber = idArray[indexPath.item]
        routeToDetailVC(with: recipeNumber)
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenlCollectionViewCell", for: indexPath) as? GenlCollectionViewCell else { fatalError("") }
        
        let model: DetailResponseModel = self.detailModels[indexPath.item]
        
        cell.configureCell(with: model)
        return cell
    }
}

private extension FavoriteViewController {
    func routeToDetailVC(with id: Int) {
        let viewController = DetailViewController()
        viewController.configureDetailViewController(with: id)
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


private func loadDetailModelsFromUserDefaults() -> [DetailResponseModel]? {
    let defaults = UserDefaults.standard
    
    if let savedData = defaults.data(forKey: "savedDetailModels") {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([DetailResponseModel].self, from: savedData)
            return decodedData
        } catch {
            print("Error decoding data: \(error)")
        }
    }
    return nil
}
