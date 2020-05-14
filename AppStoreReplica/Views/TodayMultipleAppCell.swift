//
//  TodayMultipleAppCell.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 5/13/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

class BaseTodayCell: UICollectionViewCell {
	
	var todayItem: TodayItem!
	
}

import UIKit
class TodayMultipleAppCell: BaseTodayCell {
	static let reuseID = "TodayMultipleAppCell"
	override var todayItem: TodayItem! {
		didSet {
			categoryLabel.text = todayItem.category
			titleLabel.text = todayItem.title
			
			multipleAppsController.apps = todayItem.apps
			multipleAppsController.collectionView.reloadData()
		}
	}
	
	let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
	let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 32), numberOfLines: 2)
	
	 let multipleAppsController = TodayMultipleAppsController(mode: .small)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .white
		layer.cornerRadius = 16
		
		let stackView = VerticalStackView(arrangedSubviews: [
			categoryLabel,
			titleLabel,
			multipleAppsController.view
		], spacing: 12)
		
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
}
