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
}
