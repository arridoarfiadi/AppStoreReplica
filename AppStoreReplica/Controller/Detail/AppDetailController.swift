//
//  AppDetailController.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 5/4/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	var appId: String! {
		didSet {
			let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
			Service.shared.fetchGenericeJSONData(urlString: urlString) { [weak self] (result: SearchResult?, err) in
				guard let self = self else {return}
				self.app = result?.results.first
				DispatchQueue.main.async {
					self.collectionView.reloadData()
				}
			}
			let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId ?? "")/sortby=mostrecent/json?l=en&cc=us"
            Service.shared.fetchGenericeJSONData(urlString: reviewsUrl) { [weak self] (reviews: Reviews?, err) in
                guard let self = self else {return}
                if let err = err {
                    print("Failed to decode reviews:", err)
                    return
                }
                
                self.reviews = reviews
                reviews?.feed.entry.forEach({print($0.rating.label)})
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
			}
		}
	}
	
	var app: Result?
	 var reviews: Reviews?
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .white
		
		collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: AppDetailCell.reuseID)
		collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: PreviewCell.reuseID)
		collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: ReviewRowCell.reuseID)
		navigationItem.largeTitleDisplayMode = .never
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.item == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailCell.reuseID, for: indexPath) as! AppDetailCell
			cell.setup(for: app)
			return cell
			
		}
		else if indexPath.item == 1 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCell.reuseID, for: indexPath) as! PreviewCell
			cell.horizontalController.app = self.app
			return cell
		}  else  {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewRowCell.reuseID, for: indexPath) as! ReviewRowCell
			 cell.reviewsController.reviews = self.reviews
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var height: CGFloat = 280
		
		if indexPath.item == 0 {
			// calculate the necessary size for our cell somehow
			let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
			dummyCell.setup(for: app)
			dummyCell.layoutIfNeeded()
			
			let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
			height = estimatedSize.height
		} else if indexPath.item == 1 {
			height = 500
		} else {
			height = 280
		}
		
		return .init(width: view.frame.width, height: height)	}
}
