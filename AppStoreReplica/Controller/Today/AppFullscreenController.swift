//
//  AppFullscreenController.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 5/5/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

import UIKit

class AppFullscreenController: UITableViewController {
	 var dismissHandler: (() ->())?
	 var todayItem: TodayItem?
	 
	 override func viewDidLoad() {
		 super.viewDidLoad()
		 
		 tableView.tableFooterView = UIView()
		 tableView.separatorStyle = .none
		 tableView.allowsSelection = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
	 }
	 
	 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		 return 2
	 }
	 
	 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		 
		 if indexPath.item == 0 {
			 let headerCell = AppFullscreenHeaderCell()
			 headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
			 headerCell.todayCell.todayItem = todayItem
			 headerCell.todayCell.layer.cornerRadius = 0
			headerCell.clipsToBounds = true
			 return headerCell
		 }
		 
		 let cell = AppFullscreenDescriptionCell()
		 return cell
	 }
	 
	 @objc fileprivate func handleDismiss(button: UIButton) {
		 button.isHidden = true
		 dismissHandler?()
	 }
	 
	 override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		 if indexPath.row == 0 {
			 return 450
		 }
		 return super.tableView(tableView, heightForRowAt: indexPath)
	 }
	 
}
