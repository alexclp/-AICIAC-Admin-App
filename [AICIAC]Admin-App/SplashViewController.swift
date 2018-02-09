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
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if UserDefaults.isFirstLaunch() {
			// launch calibration view controller
			self.performSegue(withIdentifier: "showCornersListSegue", sender: self)
		} else {
			// go to measurements
			self.performSegue(withIdentifier: "showFloorListSegue", sender: self)
		}
	}

}
