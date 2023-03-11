//
//  DetailView.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 06.03.2023.
//

import UIKit

final class DetailView: UIView {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        return tableView
    }()
        
    var detailViewModel: [DetailViewModel] = []
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDetailTableView(with model: DetailResponseModel) {
        detailViewModel = model.extendedIngredients.map({ elem in
                .init(nameClean: elem.nameClean, amount: elem.amount, unit: elem.unit, isSelected: false)
        })
        tableView.reloadData()
    }
}

extension DetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if detailViewModel[indexPath.item].isSelected {
            detailViewModel[indexPath.item].isSelected = false
        } else {
            detailViewModel[indexPath.item].isSelected = true
        }
        tableView.reloadData()
    }
}

extension DetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailViewModel.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        let model = detailViewModel[indexPath.item]
        cell.selectionStyle = .none
        cell.configureCell(with: model)
        return cell
    }
}

private extension DetailView {
    func setupView() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        myAddSubView(tableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
