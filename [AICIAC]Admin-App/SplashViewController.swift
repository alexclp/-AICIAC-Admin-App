//
//  SplashViewController.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 08/02/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if UserDefaults.isFirstLaunch() {
			// launch calibration view controller
			performSegue(withIdentifier: "showCornersListSegue", sender: self)
		} else {
			// go to measurements
			performSegue(withIdentifier: "showFloorListSegue", sender: self)
		}
    }

}
