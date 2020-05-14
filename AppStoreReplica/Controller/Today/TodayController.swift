//
//  TodayController.swift
//  AppStoreReplica
//
//  Created by Arrido Arfiadi on 5/5/20.
//  Copyright © 2020 Arrido Arfiadi. All rights reserved.
//

import UIKit


class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
	var appFullscreenController: AppFullscreenController?
	var topConstraint: NSLayoutConstraint?
	var leadingConstraint: NSLayoutConstraint?
	var widthConstraint: NSLayoutConstraint?
	var heightConstraint: NSLayoutConstraint?
	let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
	var apps = [TodayItem]()
	
	fileprivate func fetchData() {
        // dispatchGroup
        self.activityIndicatorView.startAnimating()
        let dispatchGroup = DispatchGroup()
        
        var topGrossingGroup: AppGroup?
        var gamesGroup: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, err) in
            // make sure to check your errors
            topGrossingGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, err) in
            gamesGroup = appGroup
            dispatchGroup.leave()
        }
        
        // completion block
        dispatchGroup.notify(queue: .main) {
            // I'll have access to top grossing and games somehow
            
            print("Finished fetching")
            self.activityIndicatorView.stopAnimating()
            
            self.apps = [
                TodayItem.init(category: "Daily List", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
                
                TodayItem.init(category: "Daily List", title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),
                
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
            ]
            
            self.collectionView.reloadData()
        }
        
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
        
		collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayCell.reuseID)
		collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayMultipleAppCell.reuseID)
		view.addSubview(activityIndicatorView)
			   activityIndicatorView.centerInSuperview()
		fetchData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		   super.viewWillAppear(animated)
		   
		   tabBarController?.tabBar.superview?.setNeedsLayout()
	   }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if apps[indexPath.item].cellType == .multiple {
				   let fullController = TodayMultipleAppsController(mode: .fullscreen)
				   fullController.apps = self.apps[indexPath.item].apps
				   present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
				   return
			   }
		
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = apps[indexPath.row]
        appFullscreenController.dismissHandler = {
            self.handleRemoveAppFullScreenControllerView()
        }
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)

        addChild(appFullscreenController)
        
        self.appFullscreenController = appFullscreenController
        
        self.collectionView.isUserInteractionEnabled = false
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordindates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame

        // auto layout constraint animations
        // 4 anchors
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        self.view.layoutIfNeeded()
        
        fullscreenView.layer.cornerRadius = 16
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation

            
			guard let cell = self.appFullscreenController?.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
			self.navigationController?.navigationBar.isHidden = true
			self.tabBarController?.tabBar.isHidden = true
        }, completion: nil)
    }
    
    var startingFrame: CGRect?
    
    @objc func handleRemoveAppFullScreenControllerView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
			            
			self.appFullscreenController?.tableView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else { return }
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
			guard let cell = self.appFullscreenController?.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
			
        }, completion: { _ in
			self.appFullscreenController?.view.removeFromSuperview()
			self.appFullscreenController?.removeFromParent()
			
            self.collectionView.isUserInteractionEnabled = true
			self.navigationController?.navigationBar.isHidden = false
			self.tabBarController?.tabBar.isHidden = false
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return apps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellId = apps[indexPath.item].cellType == .single ? TodayCell.reuseID : TodayMultipleAppCell.reuseID
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = apps[indexPath.item]
        return cell
    }
     static let cellSize: CGFloat = 500
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
}
