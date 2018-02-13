//
//  Utils.swift
//  [AICIAC]Admin-App
//
//  Created by Alexandru Clapa on 12/02/2018.
//  Copyright © 2018 Alexandru Clapa. All rights reserved.
//

import UIKit

class Utils: NSObject {
	static func haversineDinstance(la1: Double, lo1: Double, la2: Double, lo2: Double, radius: Double = 6367444.7) -> Double {
		
		let haversin = { (angle: Double) -> Double in
			return (1 - cos(angle))/2
		}
		
		let ahaversin = { (angle: Double) -> Double in
			return 2*asin(sqrt(angle))
		}
		
		// Converts from degrees to radians
		let dToR = { (angle: Double) -> Double in
			return (angle / 360) * 2 * Double.pi
		}
		
		let lat1 = dToR(la1)
		let lon1 = dToR(lo1)
		let lat2 = dToR(la2)
		let lon2 = dToR(lo2)
		
		return radius * ahaversin(haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * haversin(lon2 - lon1))
	}
	
	static func manhattanDistance(from: (Double, Double), to: (Double, Double)) -> Double {
		return (abs(from.0 - to.0) + abs(from.1 - to.1))
	}
	
	static func circleIntersection(floorPlanFirst: (Double, Double), floorPlanSecond: (Double, Double), first: (Double, Double), second: (Double, Double), with intersectionPoint: (Double, Double)) -> [(Double, Double)]? {
		let d1 = manhattanDistance(from: floorPlanFirst, to: intersectionPoint)
		let d2 = manhattanDistance(from: floorPlanSecond, to: intersectionPoint)
		let d = Darwin.hypot(floorPlanSecond.1 - floorPlanFirst.1,
					  floorPlanSecond.0 - floorPlanFirst.0)
		
		if (d <= d1 + d2 && d >= abs(d2 - d1)) {
			let ex = (second.0 - first.0) / d
			let ey = (second.1 - first.1) / d
			
			let x = (d1 * d1 - d2 * d2 + d * d) / (2 * d)
			let y = sqrt(d1 * d1 - x * x)
			
			let p1 = (first.0 + x * ex - y * ey, first.1 + x * ey + y * ex)
			let p2 = (first.0 + x * ex + y * ey, first.1 + x * ey - y * ex)
			return [p1, p2]
		} else {
			print("No Intersection, far outside or one circle within the other")
			return nil
		}
	}
	
	static func interpolatePointToCurrentSize(point: CGPoint, from standardSize: CGSize, in view: UIView) -> CGPoint? {
//		guard let currentSize = (UIApplication.shared.delegate as? AppDelegate)?.window?.bounds.size else { return nil }
		let currentSize = view.bounds.size
		return CGPoint(
			x: point.x * currentSize.width / standardSize.width,
			y: point.y * currentSize.height / standardSize.height
		)
	}
}
