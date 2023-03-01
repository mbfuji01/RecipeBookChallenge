//
//  UITabbarController+Progress.swift
//  TurtleEnglish
//
//  Created by Andrey Lebedev on 14.09.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTabBar()
		setupItems()
	}
	
	private func setupTabBar() {
		
		tabBar.backgroundColor = .white
		tabBar.tintColor = .black
		tabBar.unselectedItemTintColor = .gray
		tabBar.layer.borderWidth = 1
		tabBar.layer.borderColor = UIColor.black.cgColor
	}
	
	private func setupItems() {
		
		let mainVC = MainViewController()
		let categoriesVC = CategoriesViewController()
		let favoriteVC = FavoriteViewController()
		let searchVC = SearchViewController()
		
		setViewControllers([mainVC, categoriesVC, favoriteVC, searchVC], animated: true)
		
		guard let items = tabBar.items else { return }
		
		items[0].title = "Main"
		items[1].title = "Categories"
		items[2].title = "Favorites"
		items[3].title = "Search"
		
//		items[0].image = UIImage(named: "")
//		items[1].image = UIImage(named: "")
//		items[2].image = UIImage(named: "")
		
		UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .semibold) as Any], for: .normal)
	}
}
