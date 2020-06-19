//
//  UIImage+Vrbo.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	func resizeImage(to newSize: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
		draw(in: CGRect(origin: CGPoint.init(x: 0.0, y: 0.0), size: newSize))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage!
	}
}
