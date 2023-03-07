//
//  DetailViewController.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 06.03.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let titleLabel = make(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
    }
    
    private let mainImageView = make(UIImageView()) {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.image = UIImage(named: "placeholderImage")
    }
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapbookmarkButton), for: .touchUpInside)
        button.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let caloriesLabel = make(UILabel()) {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let cookTimeLabel = make(UILabel()) {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let difficultyLabel = make(UILabel()) {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let servesLabel = make(UILabel()) {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let shortInformationStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    private let detailView = DetailView()
    
    private let mainStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    @objc
    private func didTapbookmarkButton() {
        print(#function)
    }
    
    func configureDetailViewController(with index: Int) {
        Task {
            do {
                let detailModel = try await apiService.fetchDetailAsync(id: index)
                configureDetailViews(with: detailModel)
                detailView.configureDetailTableView(with: detailModel)
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
}

private extension DetailViewController {
    func configureDetailViews(with model: DetailResponseModel) {
        guard let kcalValue = model.nutrition?.nutrients[.zero].amount else { return }
        guard let kcalUnit = model.nutrition?.nutrients[.zero].unit else { return }
        
        titleLabel.text = model.title
        mainImageView.downloaded(from: model.image)
        caloriesLabel.text = "\(kcalValue) \(kcalUnit)"
        cookTimeLabel.text = model.readyInMinutes.intToString()
        servesLabel.text = model.servings.intToString()
    }
    
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        shortInformationStackView.addArrangedSubview(caloriesLabel)
        shortInformationStackView.addArrangedSubview(cookTimeLabel)
        shortInformationStackView.addArrangedSubview(difficultyLabel)
        shortInformationStackView.addArrangedSubview(servesLabel)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(shortInformationStackView)
        mainStackView.addArrangedSubview(detailView)
        
        view.myAddSubView(mainStackView)
        view.myAddSubView(bookmarkButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            bookmarkButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 90),
            mainImageView.heightAnchor.constraint(equalToConstant: 220),
            shortInformationStackView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
