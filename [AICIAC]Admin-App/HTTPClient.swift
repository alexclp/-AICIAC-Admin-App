//
//  HTTPClient.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 29/01/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

class HTTPClient: NSObject {
	static let shared = HTTPClient()

	private override init() { }
	
	func PUT(urlString: String, parameters: [String: Any]?, completion: @escaping (Bool) -> Void) {
		let url = URL(string: urlString)
		var urlRequest = URLRequest(url: url!)
		urlRequest.httpMethod = "PATCH"
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.httpBody = "{ \"shouldScan\": 1 }".data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
			guard error == nil else {
				print(error!)
				completion(false)
				return
			}
			
			guard let data = data else {
				print("Data is empty")
				completion(false)
				return
			}
			
			let json = try! JSONSerialization.jsonObject(with: data, options: [])
			print(json)
			completion(true)
		})
		
		task.resume()
	}
}
