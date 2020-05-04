//
//  BaseTabBarController.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 4/26/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

import UIKit


class BaseTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		let todayViewController = createNavController(viewController: UIViewController(), title: "Today", imageName: "today_icon")
		let appsViewController = createNavController(viewController: AppsController(), title: "Apps", imageName: "apps")
		let searchViewController = createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search")
		viewControllers = [
			appsViewController,
			todayViewController,
			searchViewController
			
		]
		
	}
	
	fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
		viewController.view.backgroundColor = .white
		let navController = UINavigationController(rootViewController: viewController)
		navController.tabBarItem.title = title
		navController.tabBarItem.image = UIImage(named: imageName)
		navController.navigationBar.prefersLargeTitles = true
		viewController.navigationItem.title = title
		return navController
	}
}
