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
	let baseURLScanner = "https://scanner-on-off.herokuapp.com/"
	
	var imageName = ""
	var roomID = -1
	var locationID = -1
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = imageName
		setFloorPlanImage()
		setPlusButton()
    }
	
	// MARK: API
	
	func createRoom(roomName: String) {
		let params = ["name": roomName]
		HTTPClient.shared.request(urlString: baseURLAPI + "/rooms", method: "POST", parameters: params) { (success, data) in
			if success == true {
				print("Successfully created room with name \(roomName)")
				guard let data = data else { return }
				do {
					if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						if let roomID = json["roomID"] as? Int {
							self.roomID = roomID
						}
					}
				} catch {
					print(error.localizedDescription)
				}
			} else {
				print("Failed to create room with name \(roomName)")
			}
		}
	}
	
	func createLocation(x: Double, y: Double, pressure: Double, roomID: Int) {
		let params = ["x": x,
					  "y": y,
					  "pressure": pressure,
					  "roomID": roomID]
		as [String: Any]
		HTTPClient.shared.request(urlString: baseURLAPI + "locations", method: "POST", parameters: params) { (success, data) in
			if success == true {
				print("Successfully create location")
				guard let data = data else { return }
				do {
					if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						guard let locationID = json["locationID"] as? Int else { return }
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
		HTTPClient.shared.request(urlString: baseURLScanner + "/1", method: "PATCH", parameters: params) { (success, responseJSON) in
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
	
	func setPlusButton() {
		let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.plusButtonPressed(sender:)))
		self.navigationItem.rightBarButtonItem = button
	}
	
	@objc func plusButtonPressed(sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "", message: "Please select the desired action", preferredStyle: .actionSheet)
		
		let addRoomAction = UIAlertAction(title: "Add room", style: .default) { (action) in
			let alert = UIAlertController(title: "Room name", message: "Enter the room's name", preferredStyle: .alert)
			
			alert.addTextField { (textField) in
				textField.text = "Room 1"
			}
			
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
				let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
				if let text = textField.text {
					self.createRoom(roomName: text)
				}
			}))
			
			self.present(alert, animated: true, completion: nil)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			self.dismiss(animated: true, completion: nil)
		}
		
		// iPad support
		if let popoverController = alertController.popoverPresentationController {
			popoverController.barButtonItem = sender
		}

		alertController.addAction(addRoomAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
	
	// Detects a touch event on the screen
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!
		let touchPoint = touch.location(in: self.view)
		if let floorPlanImage = floorPlanImageView.image {
			let x = (touchPoint.x - floorPlanImageView.bounds.minX) * floorPlanImage.size.width / floorPlanImageView.bounds.width
			let y = (touchPoint.y - floorPlanImageView.bounds.minY) * floorPlanImage.size.height / floorPlanImageView.bounds.height
			print("Locations are x: \(x) and \(y)")
			
			if roomID != -1 {
				createLocation(x: Double(x), y: Double(y), pressure: 0.0, roomID: roomID)
			}
		}
	}
}
