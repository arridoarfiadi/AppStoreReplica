//
//  Service.swift
//  AppStoreJSONApis
//
//  Created by Brian Voong on 2/12/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import Foundation

class Service {
	
	static let shared = Service() // singleton
	
	func fetchApps(searchTerm: String,completion: @escaping (SearchResult?, Error?) -> ()) {
		print("Fetching itunes apps from Service layer")
		
		let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
		fetchGenericeJSONData(urlString: urlString, completion: completion)
	}
	
	func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> ()) {
		let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
		fetchAppGroup(urlString: urlString, completion: completion)
	}
	
	func fetchGames(completion: @escaping (AppGroup?, Error?) -> ()) {
		fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/50/explicit.json", completion: completion)
	}
	
	//helper
	func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
		fetchGenericeJSONData(urlString: urlString, completion: completion)
	}
	
	func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
		 let urlString = "https://api.letsbuildthatapp.com/appstore/social"
		fetchGenericeJSONData(urlString: urlString, completion: completion)
	 }
	
	func fetchGenericeJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
		guard let url = URL(string: urlString) else { return }
		URLSession.shared.dataTask(with: url) { (data, resp, err) in
			if let err = err {
				completion(nil, err)
				return
			}
			do {
				let objects = try JSONDecoder().decode(T.self, from: data!)
				// success
				completion(objects, nil)
			} catch {
				completion(nil, error)
			}
			}.resume()
	}
	
}
