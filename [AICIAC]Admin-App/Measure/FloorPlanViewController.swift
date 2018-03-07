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
	
	let baseURLAPI = "https://wifi-nav-api.herokuapp.com"
//	let baseURLAPI = "http://localhost:8080"
	let baseURLScanner = "https://scanner-on-off.herokuapp.com"
	
	var imageName = ""
	var roomID = -1
	var locationID = -1
	var locations = [Location]()
	var rootLocation: Location? = nil
	
	let topRightCoordinates = (51.51353, -0.117070)
	let topLeftCoordinates = (51.51298, -0.117716)
	let bottomRightCoordinates = (51.512472, -0.116762)
	let bottomLeftCoordinates = (51.512354, -0.117334)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = imageName
		setFloorPlanImage()
		getRegisteredLocations()
		print(roomID)
		locations = [Location]()
    }
	
	func getFloorNumber() -> String {
		return imageName.filter { "0123456789".contains($0) }
	}
	
	// MARK: API
	
	func getRegisteredLocations() {
		let urlString = baseURLAPI + "/locations/floor/\(getFloorNumber())"
		HTTPClient.shared.request(urlString: urlString, method: "GET", parameters: nil) { (response, data) in
			if response == true {
				guard let data = data else { return }
				do {
					if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
						for element in json {
							guard let x = element["x"] as? Double else { print("Failed to get x"); return }
							guard let y = element["y"] as? Double else { print("Faield to get y"); return }
							guard let standardHeight = element["standardHeight"] as? Double else { print("Failed to get standard height"); return }
							guard let standardWidth = element["standardWidth"] as? Double else { print("Failed standard width"); return }
							guard let lat = element["latitude"] as? Double else { print("Failed to get lat"); return }
							guard let long = element["longitude"] as? Double else { print("Failed to get long"); return }
							guard let roomID = element["roomID"] as? Int else { print("Failed to get room ID"); return }
							guard let id = element["id"] as? Int else { print("Failed to get id"); return }
							
							DispatchQueue.main.async {
								guard let interpolatedPoint = Utils.interpolatePointToCurrentSize(point: CGPoint(x: x, y: y), from: CGSize(width: standardWidth, height: standardHeight), in: self.view) else { return }
								let view = UIView(frame: CGRect(x: interpolatedPoint.x, y: interpolatedPoint.y, width: 20.0, height: 20.0))
								view.backgroundColor = UIColor.red
								self.view.addSubview(view)
								let location = Location.init(x: x, y: y, lat: lat, long: long, id: id, roomID: roomID, standardHeight: standardHeight, standardWidth: standardWidth)
								location.view = view
								self.locations.append(location)
								
							}
						}
					}
				} catch {
					print(error.localizedDescription)
				}
			}
		}
	}
	
	func createLocation(x: Double, y: Double, lat: Double, long: Double, roomID: Int) {
		let size = self.view.bounds.size
		let params = ["x": x,
					  "y": y,
					  "latitude": lat,
					  "longitude": long,
					  "standardWidth": Double(size.width),
					  "standardHeight": Double(size.height),
					  "roomID": roomID]
		as [String: Any]
		HTTPClient.shared.request(urlString: baseURLAPI + "/locations", method: "POST", parameters: params) { (success, data) in
			if success == true {
				print("Successfully created location")
				guard let data = data else { return }
				do {
					if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						guard let locationID = json["id"] as? Int else { return }
						self.locationID = locationID
						self.scannerOn(roomID: self.roomID, locationID: self.locationID)
					}
				} catch {
					print(error.localizedDescription)
				}
				
			} else {
				print("Failed to create location")
			}
		}
	}
	
	func scannerOn(roomID: Int, locationID: Int) {
		let params = ["locationID": locationID,
					  "roomID": roomID,
					  "shouldScan": 1,
					  "storeData": 1]
		as [String: Any]
		print(params)
		HTTPClient.shared.request(urlString: baseURLScanner + "/scanSwitch/1", method: "PATCH", parameters: params) { (success, responseJSON) in
			if success == true {
				print("Successfully turned scanner on")
			} else {
				print("Failed to turn scanner on")
			}
		}
	}
	
	func makeConnectionBetweenLocations(location1: Location, location2: Location, completion: @escaping (Bool) -> Void) {
		let params = ["rootLocationID": location1.id,
					  "childLocationID": location2.id]
		HTTPClient.shared.request(urlString: "\(baseURLAPI)/locationConnections", method: "POST", parameters: params) { (response, data) in
			completion(response)
		}
	}
	
	// MARK: UI Methods

	func setFloorPlanImage() {
		floorPlanImageView.image = UIImage(named: imageName)
	}
	
	// Detects a touch event on the screen
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first!
		let touchPoint = touch.location(in: self.view)
		
		let touchedView = self.view.hitTest(touchPoint, with: event)
		for location in locations {
			if location.view! == touchedView {
				print("Found location with id: \(location.id)")
				if let root = rootLocation {
					let childLocation = location
					makeConnectionBetweenLocations(location1: root, location2: childLocation) { (response) in
						print(response)
					}
				} else {
					rootLocation = location
					location.view?.backgroundColor = UIColor.blue
				}
			}
		}
		
		let topLeftPosition = (UserDefaults.standard.double(forKey: "topLeftX"),
							   UserDefaults.standard.double(forKey: "topLeftY"))
		let bottomLeftPosition = (UserDefaults.standard.double(forKey: "bottomLeftX"),
								  UserDefaults.standard.double(forKey: "bottomLeftY"))
		guard let touchPointCoordinates = Utils.circleIntersection(floorPlanFirst: topLeftPosition, floorPlanSecond: bottomLeftPosition, first: topLeftCoordinates, second: bottomLeftCoordinates, with: (Double(touchPoint.x), Double(touchPoint.y)))?[1] else { return }
		print(touchPoint)
		print(touchPointCoordinates)
		if roomID != -1 {
//			createLocation(x: Double(touchPoint.x), y: Double(touchPoint.y), lat: touchPointCoordinates.0, long: touchPointCoordinates.1, roomID: roomID)
		}
	}
	
	
}
