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
	
	var imageName = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setFloorPlanImage()
    }

	func setFloorPlanImage() {
		floorPlanImageView.image = UIImage(named: imageName)
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
