//
//  CornerViewController.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 08/02/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

enum CornerList: String {
	case topRight = "topRight"
	case topLeft = "topLeft"
	case bottomRight = "bottomRight"
	case bottomLeft = "bottomLeft"
	case none = "none"
}

class CornerViewController: UIViewController {
	@IBOutlet weak var floorImageView: UIImageView!
	
	var selectedCorner = CornerList.none
	let topRightCoordinates = (51.51353, -0.117070)
	let topLeftCoordinates = (51.51298, -0.117716)
	let bottomRightCoordinates = (51.512472, -0.116762)
	let bottomLeftCoordinates = (51.512354, -0.117334)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if let rawValue = UserDefaults.standard.string(forKey: "selectedCorner") {
			selectedCorner = CornerList(rawValue: rawValue)!
		}
    }

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!
		let touchPoint = touch.location(in: self.floorImageView)
		print("Selected corner is: \(selectedCorner)")
		let x = Double(touchPoint.x)
		let y = Double(touchPoint.y)
		print("Setting coordinates: \(x, y)")
		if selectedCorner == CornerList.bottomLeft {
			UserDefaults.standard.set(x, forKey: "bottomLeftX")
			UserDefaults.standard.set(y, forKey: "bottomLeftY")
		} else if selectedCorner == CornerList.bottomRight {
			UserDefaults.standard.set(x, forKey: "bottomRightX")
			UserDefaults.standard.set(y, forKey: "bottomRightY")
		} else if selectedCorner == CornerList.topLeft {
			UserDefaults.standard.set(x, forKey: "topLeftX")
			UserDefaults.standard.set(y, forKey: "topLeftY")
		} else if selectedCorner == CornerList.topRight {
			UserDefaults.standard.set(x, forKey: "topRightX")
			UserDefaults.standard.set(y, forKey: "topRightY")
		}
		UserDefaults.standard.synchronize()
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func doneButtonPressed(sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
}
