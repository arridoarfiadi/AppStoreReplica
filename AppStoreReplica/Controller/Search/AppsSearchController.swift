//
//  AppsSearchController.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 4/26/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

import UIKit
import SDWebImage

class AppsSearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
	
	
	fileprivate let searchController = UISearchController(searchResultsController: nil)
	fileprivate let enterSearchTemLabel:UILabel = {
		let label = UILabel()
		label.text = "Please enter search term above..."
		label.textAlignment = .center
		label.font = UIFont.boldSystemFont(ofSize: 20)
		return label
	}()
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .white
		collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.REUSE_ID)
		view.addSubview(enterSearchTemLabel)
		enterSearchTemLabel.fillSuperview()
		setupSearchBar()
		
	}
	
	fileprivate func setupSearchBar() {
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchBar.delegate = self
	}
	
	var timer:Timer?
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
			self.fetchItunesApps(searchTerm: searchText)
		})
		
	}
	
	fileprivate var appResults = [Result]()
	
	fileprivate func fetchItunesApps(searchTerm: String) {
		Service.shared.fetchApps(searchTerm: searchTerm) { (results, err) in
			
			if let err = err {
				print("Failed to fetch apps:", err)
				return
			}
			
			self.appResults = results?.results ?? []
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
		
		// we need to get back our search results somehow
		// use a completion block
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.REUSE_ID, for: indexPath) as! SearchResultCell
		 cell.appResult = appResults[indexPath.item]
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		enterSearchTemLabel.isHidden = !appResults.isEmpty
		return appResults.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 350)
	}
	
	
}
