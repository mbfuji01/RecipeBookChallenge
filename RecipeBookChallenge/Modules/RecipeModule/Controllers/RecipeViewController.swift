//
//  RecipeViewController.swift
//  RecipeBookChallenge
//
//  Created by demasek on 01.03.2023.
//

import UIKit

class RecipeViewController: UIViewController {
    
    //MARK: - Create UI
    
    private lazy var recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    var tableVC = TableViewCell()
    var viewModel: RecipeModel?
    var receptModel: DetailResponseModel?
    var recipeId: Int = 0
    
    private lazy var caloriesLabel = UILabel.recipeTopItemLabel
    private lazy var timeLabel = UILabel.recipeTopItemLabel
    private lazy var servesLabel = UILabel.recipeTopItemLabel
    private lazy var recipeDescriptionStackView = UIStackView()
    private lazy var tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "table")
        tableView.showsVerticalScrollIndicator = false
        
        fetchRecept()
        fetchIngridient()
        setupViews()
        setConstraints()
    }
    
    func fetchRecipeId(index: Int) {
        recipeId = index
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        recipeTitleLabel.text = " "
        recipeDescriptionStackView = UIStackView(arrangedSubviews:[caloriesLabel, timeLabel, servesLabel], axis: .horizontal, spacing: 10)
        recipeDescriptionStackView.distribution = .equalSpacing
        view.addSubview(recipeTitleLabel)
        view.addSubview(recipeImageView)
        view.addSubview(favoriteButton)
        view.addSubview(recipeDescriptionStackView)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        
    }
    //MARK:  Обновляем экран согласно рецепта
    private func fetchTopViewLabel (model: DetailResponseModel) {
        recipeTitleLabel.text = model.title
        caloriesLabel.text = "\(model.readyInMinutes) calories"  //пока берутся минуты на подготовку, нужно исправить
        timeLabel.text = "\(model.readyInMinutes) min"
        servesLabel.text = "\(model.servings) servings"
        recipeImageView.downloaded(from: model.image)
    }
    
    
    @objc
    private func favoriteButtonTapped() {
        print("favoriteButtonTapped")
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        recipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recipeTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 31),
            recipeTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recipeTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: 45),
            recipeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recipeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor, multiplier: 0.56)
        ])
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -10)
        ])
        recipeDescriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recipeDescriptionStackView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 20),
            recipeDescriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            recipeDescriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: recipeDescriptionStackView.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
        ])
    }
}

//MARK: - Create TableView Cell

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "table", for: indexPath) as!
        TableViewCell
        let reversedIndex = (self.viewModel?.ingredients.count ?? 0) - 1 - indexPath.row
        guard let model = self.viewModel?.ingredients[reversedIndex] else {
            return UITableViewCell()
        }
        cell.configurateCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
            cell.favoriteButtonTapped()
        }
    }
}
//MARK: Получаем модель на рецепт и ингридиенты.
extension RecipeViewController {
    
    func fetchRecept() {
        Task(priority: .utility) {
            do {
                let recept = try await apiService.fetchDetailAsync(id: recipeId)
                receptModel = recept
                await MainActor.run(body: {
                    fetchTopViewLabel(model: recept)
                })
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
    
    func fetchIngridient() {
        Task(priority: .utility) {
            do {
                let ingridient = try await apiService.fetchIngridientsAsync(id: recipeId)
                viewModel = ingridient
                await MainActor.run(body: {
                    tableView.reloadData()
                })
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
}



