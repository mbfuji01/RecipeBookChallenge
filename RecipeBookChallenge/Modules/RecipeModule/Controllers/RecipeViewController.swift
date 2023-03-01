//
//  RecipeViewController.swift
//  RecipeBookChallenge
//
//  Created by demasek on 01.03.2023.
//

import Foundation
import UIKit

class RecipeViewController: UIViewController {
	enum Constants {
		static let welcomeToChallenge: String = "welcome to challenge" // Пример заполнения данных в константы, удалить строку при начале работы с контроллером
	}
	
	//MARK: - Create UI
	
	private lazy var recipeTitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
		label.textColor = .black
		label.numberOfLines = 0
//		label.textAlignment = .center
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
    
    private lazy var recipeColectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let colection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        colection.backgroundColor = .black
        return colection
    }()
	
	private lazy var caloriesLabel = UILabel.recipeTopItemLabel
	private lazy var timeLabel = UILabel.recipeTopItemLabel
	private lazy var difficultLabel = UILabel.recipeTopItemLabel
	private lazy var servesLabel = UILabel.recipeTopItemLabel
	
	private lazy var recipeDescriptionStackView = UIStackView()
	
	//MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setConstraints()
	}
	
	private func setupViews() {
		view.backgroundColor = .white
		recipeTitleLabel.text = "How to make Tasty Fish (point & Kill)"
		recipeImageView.image = UIImage(named: "trendImage")
		caloriesLabel.text = "240 Calories"
		timeLabel.text = "40 Min"
		difficultLabel.text = "Easy"
		servesLabel.text = "Serves 2"
		
		recipeDescriptionStackView = UIStackView(arrangedSubviews:[caloriesLabel, timeLabel, difficultLabel, servesLabel], axis: .horizontal, spacing: 10)
		recipeDescriptionStackView.distribution = .equalSpacing
        

        
		view.addSubview(recipeTitleLabel)
		view.addSubview(recipeImageView)
		view.addSubview(favoriteButton)
		view.addSubview(recipeDescriptionStackView)
        view.addSubview(recipeColectionView)
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
        recipeColectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recipeColectionView.topAnchor.constraint(equalTo: recipeDescriptionStackView.bottomAnchor, constant: 20),
            recipeColectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            recipeColectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
	}
}



