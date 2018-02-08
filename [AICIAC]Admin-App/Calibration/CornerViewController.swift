//
//  CornerViewController.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 08/02/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

enum CornerList {
	case topRight
	case topLeft
	case bottomRight
	case bottomLeft
}

class CornerViewController: UIViewController {
	@IBOutlet weak var floorImageView: UIImageView!
	
	var selectedCorner = CornerList.self
	var topRightCoordinates = (51.51353, -0.117070)
	var topLeftCoordinates = (51.51298, -0.117716)
	var bottomRightCoordinates = (51.512472, -0.116762)
	var bottomLeftCoordinates = (51.512354, -0.117334)
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
