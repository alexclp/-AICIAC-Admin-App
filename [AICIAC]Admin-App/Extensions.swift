//
//  Extensions.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 30/01/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
	func jsonString() -> String? {
		let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
		guard jsonData != nil else { return nil }
		let jsonString = String(data: jsonData!, encoding: .utf8)
		guard jsonString != nil else { return nil }
		return jsonString! as String
	}
}

extension UserDefaults {
	static func isFirstLaunch() -> Bool {
		let flagName = "launched"
		
		if UserDefaults.standard.integer(forKey: flagName) != 2 {
			return true
		}
		
		UserDefaults.standard.set(2, forKey: flagName)
		UserDefaults.standard.synchronize()
		return false
	}
}
