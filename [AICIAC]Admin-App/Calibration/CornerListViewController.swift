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

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showCornerViewModalSegue" {
			UserDefaults.standard.set(selectedCorner.rawValue, forKey: "selectedCorner")
			UserDefaults.standard.synchronize()
		}
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
			selectedCorner = .topLeft
		} else if indexPath.row == 1 {
			cell.textLabel?.text = "Top right corner"
			selectedCorner = .topRight
		} else if indexPath.row == 2 {
			cell.textLabel?.text = "Bottom left corner"
			selectedCorner = .bottomLeft
		} else if indexPath.row == 3 {
			cell.textLabel?.text = "Bottom right corner"
			selectedCorner = .bottomRight
		}
		return UITableViewCell()
	}
}

extension CornerListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: "showCornerViewModalSegue", sender: self)
	}
}
