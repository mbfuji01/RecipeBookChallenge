//
//  MoreInfoViewController.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 09.03.2023.
//

import UIKit

final class MoreInfoViewController: UIViewController {
    
    private let summaryLabel = make(UILabel()) {
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingOverlay.shared.showOverlay(view: summaryLabel)
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoadingOverlay.shared.hideOverlayView()
    }
    
    func configureMoreInformationVC(with index: Int) {
        Task(priority: .userInitiated) {
            do {
                let response = try await apiService.fetchDetailAsync(id: index)
                summaryLabel.text = response.instructions
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
}

private extension MoreInfoViewController {
    func setupViewController() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.backgroundColor = .white
        view.addSubviews(summaryLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
