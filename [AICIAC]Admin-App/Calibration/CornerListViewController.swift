//
//  CornerListViewController.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 08/02/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

class CornerListViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	var selectedCorner = CornerList.none

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if checkIfDataExists() == true {
			showDoneButton()
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showCornerViewModalSegue" {
			UserDefaults.standard.set(selectedCorner.rawValue, forKey: "selectedCorner")
			UserDefaults.standard.synchronize()
		}
	}
	
	func showDoneButton() {
		let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonPressed(sender:)))
		self.navigationItem.rightBarButtonItem = button
	}
	
	@objc func doneButtonPressed(sender: UIBarButtonItem) {
		performSegue(withIdentifier: "finishedCalibrationSegue", sender: self)
	}
	
	func checkIfDataExists() -> Bool {
		return (
			UserDefaults.standard.double(forKey: "topLeftX") != 0.0 &&
			UserDefaults.standard.double(forKey: "topLeftY") != 0.0 &&
			UserDefaults.standard.double(forKey: "topRightX") != 0.0 &&
			UserDefaults.standard.double(forKey: "bottomLeftX") != 0.0 &&
			UserDefaults.standard.double(forKey: "bottomLeftY") != 0.0 &&
			UserDefaults.standard.double(forKey: "bottomRightX") != 0.0 &&
			UserDefaults.standard.double(forKey: "bottomRightY") != 0.0
		)
	}
}

extension CornerListViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cornerCell", for: indexPath)
		
		if indexPath.row == 0 {
			cell.textLabel?.text = "Top left corner"
			return cell
		} else if indexPath.row == 1 {
			cell.textLabel?.text = "Top right corner"
			return cell
		} else if indexPath.row == 2 {
			cell.textLabel?.text = "Bottom left corner"
			return cell
		} else if indexPath.row == 3 {
			cell.textLabel?.text = "Bottom right corner"
			return cell
		}
		return UITableViewCell()
	}
}

extension CornerListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.row == 0 {
			selectedCorner = .topLeft
		} else if indexPath.row == 1 {
			selectedCorner = .topRight
		} else if indexPath.row == 2 {
			selectedCorner = .bottomLeft
		} else if indexPath.row == 3 {
			selectedCorner = .bottomRight
		}
		performSegue(withIdentifier: "showCornerViewModalSegue", sender: self)
	}
}
