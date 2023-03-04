//
//  MainViewController.swift
//  RecipeBookChallenge
//
//  Created by demasek on 26.02.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let titleLabel = make(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.text = "Get amazing recipes for cooking"
    }
    
    private let trendLabel = make(UILabel()) {
        $0.text = "Trending now 🔥"
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapSeeAllTrendsButton), for: .touchUpInside)
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
    
    private let savedLabel = make(UILabel()) {
        $0.text = "Saved recipe"
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private lazy var seeAllsavedButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapSeeAllsavedButton), for: .touchUpInside)
        button.setTitle("See all", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.tintColor = .red
        return button
    }()
    
    private let savedStackView = make(UIStackView()) {
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
    private let savedView = SavedView()
    private let mainBrain = MainBrain()
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        fetchTrendsAsync()
    }
	
	func routeToRecipe(with indexPath: IndexPath) {
//		let id = itemsId[indexPath]
		let recipeVC = RecipeViewController()
		present(recipeVC, animated: true)
	}
    
    @objc
    private func didTapSeeAllTrendsButton() {
        print(#function)
    }
    
    @objc
    private func didTapSeeAllsavedButton() {
        print(#function)
    }
}
var itemsId = [Int]()
private extension MainViewController {
    func fetchTrendsAsync() {
        Task(priority: .utility) {
            do {
                let trends = try await apiService.fetchTrendssAsync()
                await MainActor.run(body: {
                    trendView.configureDetailView(with: trends)
                })
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
			
        }
    }
    
//    func fetchTrendsAsync() {
//        Task(priority: .utility) {
//            do {
//                let trends = try await apiService.fetchTrendssAsync()
//                await MainActor.run(body: {
//                    trends.results.forEach({ element in
//                        idArray.append(element.id)
//                    })
//                    print(idArray)
//                    trendView.configureTrendView(with: trends)
//                })
//            } catch {
//                await MainActor.run(body: {
//                    print(error, error.localizedDescription)
//                })
//            }
//        }
//    }
 
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        trendStackView.addArrangedSubview(trendLabel)
        trendStackView.addArrangedSubview(seeAllButton)
        
        savedStackView.addArrangedSubview(savedLabel)
        savedStackView.addArrangedSubview(seeAllsavedButton)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(trendStackView)
        mainStackView.addArrangedSubview(trendView)
        mainStackView.addArrangedSubview(savedStackView)
        mainStackView.addArrangedSubview(savedView)
        
        view.myAddSubView(mainStackView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            trendView.heightAnchor.constraint(equalToConstant: 280),
            savedView.heightAnchor.constraint(equalToConstant: 230),
            seeAllButton.widthAnchor.constraint(equalToConstant: 65),
            seeAllsavedButton.widthAnchor.constraint(equalToConstant: 65)
        ])
    }
}

