//
//  UIViewController+Vrbo.swift
//  VrboEventFinder
//
//  Created by mfa on 6/20/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	func addSpinner(to view: UIView) -> UIActivityIndicatorView {
		let activitySpinner = UIActivityIndicatorView(style: .large)
		view.addSubview(activitySpinner)
		activitySpinner.translatesAutoresizingMaskIntoConstraints = false
		activitySpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		activitySpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		activitySpinner.startAnimating()
		return activitySpinner
	}
}
