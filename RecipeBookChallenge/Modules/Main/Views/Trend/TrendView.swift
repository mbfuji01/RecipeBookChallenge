//
//  TrendView.swift
//  CookBook
//
//  Created by Сергей Золотухин on 27.02.2023.
//

import UIKit

protocol TrendViewDelegate: AnyObject {
    func didTapCell(at index: Int)
}

final class TrendView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 280, height: 268)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TrendCollectionViewCell.self, forCellWithReuseIdentifier: "TrendCollectionViewCell")
        return collectionView
    }()
    
    weak var delegate: TrendViewDelegate?
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    var viewModel: RecipesResponseModel?
    
    private var idArray: [Int] = []
    private var detailModels: [DetailResponseModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDetailView(with model: RecipesResponseModel) {
        model.results.forEach { element in
            idArray.append(element.id)
        }
        
        let stringArray = idArray.map { String($0) }
        let singleString = stringArray.joined(separator: ",")
        
        Task(priority: .userInitiated) {
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

extension TrendView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapCell(at: indexPath.item)
    }
}

extension TrendView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendCollectionViewCell", for: indexPath) as? TrendCollectionViewCell else { fatalError("") }

        let model: DetailResponseModel = self.detailModels[indexPath.item]
        
        cell.configureCell(with: model)
        return cell
    }
}

private extension TrendView {
    func setupView() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        myAddSubView(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
