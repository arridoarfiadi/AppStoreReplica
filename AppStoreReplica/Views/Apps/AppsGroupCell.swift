//
//  AppsGroupCell.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 4/27/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

import UIKit


class AppsGroupCell: UICollectionViewCell {
    static let REUSE_ID = "AppsGroupCell"
	
	let titleLabel: UILabel = {
		let label = UILabel(text: "App Section", font: .boldSystemFont(ofSize: 30))
		return label
	}()
	
	let horizontalController = AppsHorizontalController()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		addSubview(titleLabel)
		titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
		
		addSubview(horizontalController.view)
		horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
