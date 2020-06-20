//
//  EventTableViewCell.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var location: UILabel!
	@IBOutlet weak var schedule: UILabel!
	
	@IBOutlet weak var outerStackView: UIStackView!

	func add(_ image: UIImage) {
		let imageView = UIImageView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 75.0, height: 75.0))
		imageView.clipsToBounds = true
		imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		imageView.image = image.resizeImage(to: 75.0)
		imageView.layer.cornerRadius = 8.0
		outerStackView.insertArrangedSubview(imageView, at: 0)

		outerStackView.spacing = 10
	}

	override func prepareForReuse() {
		outerStackView.spacing = 0
		outerStackView.arrangedSubviews.compactMap { (view) -> UIImageView? in
			view as? UIImageView
		}.forEach { (image) in
			image.removeFromSuperview()
			outerStackView.removeArrangedSubview(image)
		}
	}
}
