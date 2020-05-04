//
//  AppsController.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 4/27/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

import UIKit

class AppsController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .white
		collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: AppsGroupCell.REUSE_ID)
		collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AppsPageHeader.REUSE_ID)
		view.addSubview(activityIndicatorView)
		activityIndicatorView.fillSuperview()
		fetchData()
	}
	
	let activityIndicatorView: UIActivityIndicatorView = {
		let aiv = UIActivityIndicatorView(style: .whiteLarge)
		aiv.color = .black
		aiv.startAnimating()
		aiv.hidesWhenStopped = true
		return aiv
	}()
	var socialApps = [SocialApp]()
	var groups: [AppGroup] = []
	
	fileprivate func fetchData() {
		
		var group1: AppGroup?
		var group2: AppGroup?
		var group3: AppGroup?
		
		// help you sync your data fetches together
		let dispatchGroup = DispatchGroup()
		
		dispatchGroup.enter()
		Service.shared.fetchGames { (appGroup, err) in
			print("Done with games")
			dispatchGroup.leave()
			group1 = appGroup
		}
		
		dispatchGroup.enter()
		Service.shared.fetchTopGrossing { (appGroup, err) in
			print("Done with top grossing")
			dispatchGroup.leave()
			group2 = appGroup
		}
		
		dispatchGroup.enter()
		Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, err) in
			dispatchGroup.leave()
			print("Done with free games")
			group3 = appGroup
		}
		
		dispatchGroup.enter()
		Service.shared.fetchSocialApps { (apps, err) in
			// you should check the err
			dispatchGroup.leave()
			self.socialApps = apps ?? []
			//            self.collectionView.reloadData()
		}
		
		// completion
		dispatchGroup.notify(queue: .main) {
			print("completed your dispatch group tasks...")
			
			self.activityIndicatorView.stopAnimating()
			
			if let group = group1 {
				self.groups.append(group)
			}
			if let group = group2 {
				self.groups.append(group)
			}
			if let group = group3 {
				self.groups.append(group)
			}
			self.collectionView.reloadData()
		}
	}
	
	// 2
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AppsPageHeader.REUSE_ID, for: indexPath) as! AppsPageHeader
		header.appHeaderHorizontalController.socialApps = self.socialApps
		header.appHeaderHorizontalController.collectionView.reloadData()
		return header
	}
	
	// 3
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return .init(width: view.frame.width, height: 300)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return groups.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsGroupCell.REUSE_ID, for: indexPath) as! AppsGroupCell
		let appGroup = groups[indexPath.row]
		cell.titleLabel.text = appGroup.feed.title
		cell.horizontalController.appGroup = appGroup
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 272)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return . init(top: 16, left: 0, bottom: 0, right: 0)
	}
	
}
