//
//  ViewController.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 23/01/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

class FloorSelecterViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	private var selectedFloor = 0

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showFloorPlan" {
			guard let destination = segue.destination as? FloorPlanViewController else { return }
			destination.imageName = "bh_\(selectedFloor)th.png"
		}
	}
}

extension FloorSelecterViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "floorCell", for: indexPath)
		if indexPath.row == 0 && indexPath.section == 0 {
			cell.textLabel?.text = "Floor 5"
			return cell
		} else if indexPath.row == 1 && indexPath.section == 0 {
			cell.textLabel?.text = "Floor 6"
			return cell
		} else if indexPath.row == 2 && indexPath.section == 0 {
			cell.textLabel?.text = "Floor 7"
			return cell
		}
		return UITableViewCell()
	}
}

extension FloorSelecterViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedFloor = 5 + indexPath.row
		performSegue(withIdentifier: "showFloorPlan", sender: self)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
