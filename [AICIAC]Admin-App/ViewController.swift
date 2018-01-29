//
//  ViewController.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 23/01/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	@IBAction func scanOnPressed(sender: UIButton) {
		HTTPClient.shared.PUT(urlString: "https://scanner-on-off.herokuapp.com/scanSwitch/1", parameters: nil) { (response) in
			if response == true {
				print("Success!!")
			} else {
				print("Failed!!")
			}
		}
	}

}

