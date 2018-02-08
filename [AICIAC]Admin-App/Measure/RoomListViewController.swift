//
//  RoomListViewController.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 31/01/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

class RoomListViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	var roomList = [[String: Any]]()
	var selectedFloor = 0
	var selectedRoom = [String: Any]()
	let baseURLAPI = "https://wifi-nav-api.herokuapp.com"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = "Room List"
		getRooms(for: selectedFloor)
		setPlusButton()
    }

	// MARK: API
	
	func createRoom(roomName: String, floorNumber: Int) {
		let params = ["name": roomName,
					  "floorNumber": floorNumber]
			as [String: Any]
		HTTPClient.shared.request(urlString: baseURLAPI + "/rooms", method: "POST", parameters: params) { (success, data) in
			if success == true {
				print("Successfully created room with name \(roomName)")
				self.getRooms(for: self.selectedFloor)
			} else {
				print("Failed to create room with name \(roomName)")
			}
		}
	}
	
	func getRooms(for floorNumber: Int) {
		HTTPClient.shared.request(urlString: baseURLAPI + "/rooms/floor/\(floorNumber)", method: "GET", parameters: nil) { (success, data) in
			if success == true {
				do {
					guard let data = data else { return }
					if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
						print(json)
						self.roomList = json
						
						DispatchQueue.main.async {
							self.tableView.reloadData()
						}
					}
				} catch {
					print(error.localizedDescription)
				}
			}
		}
	}
	
	func deleteRoom(at indexPath: IndexPath) {
		guard let roomID = roomList[indexPath.row]["id"] as? Int else { return }
		HTTPClient.shared.request(urlString: baseURLAPI + "/rooms/\(roomID)", method: "DELETE", parameters: nil) { (success, data) in
			if success == true {
				self.roomList.remove(at: indexPath.row)
				
				DispatchQueue.main.async {
					self.tableView.deleteRows(at: [indexPath], with: .fade)
					self.tableView.reloadData()
				}
				
				print("Successfully deleted room")
			} else {
				print("Failed to delete room")
			}
		}
	}
	
	func clearDataForRoom(at indexPath: IndexPath) {
		guard let roomID = roomList[indexPath.row]["id"] as? Int else { return }
		HTTPClient.shared.request(urlString: baseURLAPI + "/rooms/clearData/\(roomID)", method: "DELETE", parameters: nil) { (success, responseData) in
			if success == true {
				print("Successfully cleared data!")
			} else {
				print("Failed to clear data for room")
			}
		}
	}
	
	// MARK: UI
	
	func setPlusButton() {
		let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.plusButtonPressed(sender:)))
		self.navigationItem.rightBarButtonItem = button
	}
	
	@objc func plusButtonPressed(sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "Room details", message: "Enter the room's name", preferredStyle: .alert)
		
		alertController.addTextField { (textField) in
			textField.text = "Room 1"
		}
		
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertController] (_) in
			let roomNameTextField = alertController!.textFields![0] // Force unwrapping because we know it exists.
			if let roomName = roomNameTextField.text {
				self.createRoom(roomName: roomName, floorNumber: self.selectedFloor)
			}
		}))
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
			self.dismiss(animated: true, completion: nil)
		}))
		
		// iPad support
		if let popoverController = alertController.popoverPresentationController {
			popoverController.barButtonItem = sender
		}

		present(alertController, animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showFloorPlan" {
			guard let destination = segue.destination as? FloorPlanViewController else { return }
			guard let roomID = selectedRoom["id"] as? Int else { return }
			destination.roomID = roomID
			destination.imageName = "bh_\(selectedFloor)th.png"
		}
	}
}

extension RoomListViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return roomList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
		let room = roomList[indexPath.row]
		if let name = room["name"] as? String {
			cell.textLabel?.text = name
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let more = UITableViewRowAction(style: .normal, title: "Clear") { action, index in
			print("more button tapped")
			self.clearDataForRoom(at: indexPath)
		}
		more.backgroundColor = UIColor.gray
		
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
			self.deleteRoom(at: indexPath)
		}
		return [delete, more]
	}
}

extension RoomListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedRoom = roomList[indexPath.row]
		self.performSegue(withIdentifier: "showFloorPlan", sender: self)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
