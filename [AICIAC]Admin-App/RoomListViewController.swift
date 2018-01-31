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
	let baseURLAPI = "https://wifi-nav-api.herokuapp.com"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = "Room List"
		getRooms(for: selectedFloor)
    }

	// MARK: Data fetch
	
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
}

extension RoomListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
