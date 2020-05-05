//
//  AppsHorizontalController.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 4/27/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

import UIKit

class AppsHorizontalController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout {
	var appGroup: AppGroup? {
		didSet {
			collectionView.reloadData()
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .white
		collectionView.contentInset = .init(top: topBottomPadding, left: 16, bottom: topBottomPadding, right: 16)
		collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: AppRowCell.REUSE_ID)
		
		if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
			layout.scrollDirection = .horizontal
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return appGroup?.feed.results.count ?? 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCell.REUSE_ID, for: indexPath) as! AppRowCell
        let app = appGroup?.feed.results[indexPath.item]
        cell.nameLabel.text = app?.name
        cell.companyLabel.text = app?.artistName
        cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
		return cell
	}
	
	let topBottomPadding: CGFloat = 12
	let lineSpacing: CGFloat = 10
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let height = (view.frame.height - topBottomPadding - topBottomPadding - lineSpacing - lineSpacing) / 3
		
		return .init(width: view.frame.width - 48, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return lineSpacing
	}
	

}
