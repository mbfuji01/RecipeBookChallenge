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
    
    private lazy var trendView: TrendView = {
        let trendView = TrendView()
        trendView.delegate = self
        return trendView
    }()
        
    private let savedView = SavedView()
    
    private let mainBrain = MainBrain(apiService: APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager())))
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    private var intArray: [Int] = []
    private var detailModels: RecipesResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        fetchTrendsAsync()
    }
    
    @objc
    private func didTapSeeAllTrendsButton() {
        print(#function)
        guard let model = detailModels else { fatalError() }
        routeToGenlViewController(with: model)
    }
    
    @objc
    private func didTapSeeAllsavedButton() {
        print(#function)
    }
}

extension MainViewController: TrendViewDelegate {
    func didTapMoreInfoButton(with index: Int) {
        routeToMoreInfoVC(with: index)
    }

    func didTapCell(at index: Int) {
        let recipeNumber = intArray[index]
        routeToDetailVC(with: recipeNumber)
    }
}

private extension MainViewController {
    func routeToGenlViewController(with model: RecipesResponseModel) {
        let viewController = GenlViewController()
        guard let titleString = trendLabel.text else { return }
        //передаем во вью контроллер модель, полученную по названию категории, содержащую 10 рецептов из выбранной категории, и название тайтла
        viewController.setupGenlViewController(with: model, with: titleString)
        present(viewController, animated: true)
    }
    
    func routeToDetailVC(with id: Int) {
        let viewController = DetailViewController()
        viewController.configureDetailViewController(with: id)
        present(viewController, animated: true)
    }
    
    func routeToMoreInfoVC(with id: Int) {
        let viewController = MoreInfoViewController()
        viewController.configureMoreInformationVC(with: id)
        present(viewController, animated: true)
    }
    
    func fetchTrendsAsync() {
        Task(priority: .userInitiated) {
            do {
                let trends = try await apiService.fetchTrendssAsync()
                detailModels = trends
                intArray = trends.results.map({$0.id})
                trendView.configureDetailView(with: trends)
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
   
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

