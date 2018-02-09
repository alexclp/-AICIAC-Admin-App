//
//  FloorPlanViewController.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 29/01/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

class FloorPlanViewController: UIViewController {
	@IBOutlet weak var floorPlanImageView: UIImageView!
	
	let baseURLAPI = "https://wifi-nav-api.herokuapp.com"
	let baseURLScanner = "https://scanner-on-off.herokuapp.com"
	
	var imageName = ""
	var roomID = -1
	var locationID = -1
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = imageName
		setFloorPlanImage()
		print(roomID)
    }
	
	// MARK: API
	
	func createLocation(x: Double, y: Double, roomID: Int) {
		let params = ["x": x,
					  "y": y,
					  "roomID": roomID]
		as [String: Any]
		HTTPClient.shared.request(urlString: baseURLAPI + "/locations", method: "POST", parameters: params) { (success, data) in
			if success == true {
				print("Successfully created location")
				guard let data = data else { return }
				do {
					if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						guard let locationID = json["id"] as? Int else { return }
						self.locationID = locationID
						self.scannerOn(roomID: self.roomID, locationID: self.locationID)
					}
				} catch {
					print(error.localizedDescription)
				}
				
			} else {
				print("Failed to create location")
			}
		}
	}
	
	func scannerOn(roomID: Int, locationID: Int) {
		let params = ["locationID": locationID,
					  "roomID": roomID,
					  "shouldScan": 1]
		as [String: Any]
		HTTPClient.shared.request(urlString: baseURLScanner + "/scanSwitch/1", method: "PATCH", parameters: params) { (success, responseJSON) in
			if success == true {
				print("Successfully turned scanner on")
			} else {
				print("Failed to turn scanner on")
			}
		}
	}
	
	// MARK: UI Methods

	func setFloorPlanImage() {
		floorPlanImageView.image = UIImage(named: imageName)
	}
	
	// Detects a touch event on the screen
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!
		let touchPoint = touch.location(in: self.floorPlanImageView)
		print("Touch point is: \(touchPoint)")
		if let floorPlanImage = floorPlanImageView.image {
			let x = (touchPoint.x - floorPlanImageView.bounds.minX) * floorPlanImage.size.width / floorPlanImageView.bounds.width
			let y = (touchPoint.y - floorPlanImageView.bounds.minY) * floorPlanImage.size.height / floorPlanImageView.bounds.height
			print("Locations are x: \(x) and \(y)")
			
			if roomID != -1 {
//				createLocation(x: Double(x), y: Double(y), roomID: roomID)
			}
		}
	}
}