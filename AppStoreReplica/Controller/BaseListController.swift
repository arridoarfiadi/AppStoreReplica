//
//  BaseListController.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 4/27/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

import UIKit

class BaseListController: UICollectionViewController {
	init() {
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
