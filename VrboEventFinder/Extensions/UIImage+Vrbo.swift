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
	func resizeImage(to newWidth: CGFloat) -> UIImage? {
		let aspectRatio = self.size.width / self.size.height
		let newSize = CGSize(width: newWidth, height: newWidth / aspectRatio)

		UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
		draw(in: CGRect(origin: CGPoint.init(x: 0.0, y: 0.0), size: newSize))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}
