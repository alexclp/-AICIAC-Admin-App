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
	
	let baseURL = "https://wifi-nav-api.herokuapp.com"
	
	var imageName = ""
	var roomID = -1
	var locationID = -1
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setFloorPlanImage()
		setPlusButton()
    }
	
	// MARK: API
	
	func createRoom(roomName: String) {
		let params = ["name": roomName]
		HTTPClient.shared.request(urlString: baseURL + "/rooms", method: "POST", parameters: params) { (success, responseJSON) in
			if success == true {
				print("Successfully created room with name \(roomName)")
				if let json = responseJSON {
					if let roomID = json["roomID"] as? Int {
						self.roomID = roomID
					}
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
		HTTPClient.shared.request(urlString: baseURL + "locations", method: "POST", parameters: params) { (response, responseJSON) in
			if response == true {
				print("Successfully create location")
				if let json = responseJSON {
					if let locationID = json["locationID"] as? Int {
						self.locationID = locationID
					}
				}
			} else {
				print("Failed to create location")
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
//				let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
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
		}
	}
}
