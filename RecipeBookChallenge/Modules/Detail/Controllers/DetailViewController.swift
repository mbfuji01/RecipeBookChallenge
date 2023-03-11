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
    }
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapbookmarkButton), for: .touchUpInside)
        button.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.setImage(UIImage(named: "bookmarked")?.withRenderingMode(.alwaysOriginal), for: .selected)
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
    
    private let servesLabel = make(UILabel()) {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapbookmarkButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "ellipsis.vertical.bubble"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let shortInformationStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    private let shortAndButtonStackView = make(UIStackView()) {
        $0.spacing = 25
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    private let detailView = DetailView()
    private var indexValue: Int = 0
    
    private let mainStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingOverlay.shared.showOverlay(view: mainImageView)
        setupViewController()
    }
    
    var detailModel: DetailResponseModel?
    var savedProducts: [DetailResponseModel] = []
    
	@objc private func didTapbookmarkButton() {
		// Save the detailModels to UserDefaults
		let defaults = UserDefaults.standard
		
		let encoder = JSONEncoder()
		do {
			let encodedData = try encoder.encode(detailModel)
			let key = detailModel?.id
			defaults.set(encodedData, forKey: "\(key)")
			//                bookmarkButton.isSelected = true
			print("Data saved to UserDefaults.")
		} catch {
			print("Error encoding data: \(error)")
		}
	}
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoadingOverlay.shared.hideOverlayView()
    }
    
    @objc
    private func didTapMoreButton() {
        routeToMoreInfoVC(with: indexValue)
    }
    
    func configureDetailViewController(with index: Int) {
        Task {
            do {
                let detailModel = try await apiService.fetchDetailAsync(id: index)
                configureDetailViews(with: detailModel)
                detailView.configureDetailTableView(with: detailModel)
//                savedProducts = [detailModel]
                savedProducts.append(detailModel)
                print(savedProducts)
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
}


extension DetailViewController {
    func routeToMoreInfoVC(with id: Int) {
        let viewController = MoreInfoViewController()
        viewController.configureMoreInformationVC(with: id)
        present(viewController, animated: true)
    }
    
    func configureDetailViews(with model: DetailResponseModel) {
        guard let kcalValue = model.nutrition?.nutrients[.zero].amount else { return }
        guard let kcalUnit = model.nutrition?.nutrients[.zero].unit else { return }
        indexValue = model.id
        titleLabel.text = model.title
        guard let image = model.image else { return }
        mainImageView.downloaded(from: image)
        caloriesLabel.text = "\(Int(kcalValue)) \(kcalUnit)"
        cookTimeLabel.text = "\(model.readyInMinutes.intToString()) mins"
        servesLabel.text = "\(model.servings.intToString()) serves"
    }
    
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        shortInformationStackView.addArrangedSubview(caloriesLabel)
        shortInformationStackView.addArrangedSubview(cookTimeLabel)
        shortInformationStackView.addArrangedSubview(servesLabel)
        
        shortAndButtonStackView.addArrangedSubview(shortInformationStackView)
        shortAndButtonStackView.addArrangedSubview(moreButton)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(shortAndButtonStackView)
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
            shortInformationStackView.heightAnchor.constraint(equalToConstant: 90),
            moreButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
