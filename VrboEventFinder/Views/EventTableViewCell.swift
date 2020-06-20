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

	var eventsService: EventsService?
	var favoritesController: FavoritesController?

	var eventVM: EventViewModel? {
		didSet {
			guard let eventVM = eventVM else { return }
			name.text 		= eventVM.name
			location.text 	= eventVM.location
			schedule.text 	= eventVM.schedule

			if let imageURL = eventVM.thumbnailFile {
				eventsService?.fetchImage(imageURL) { result in
					switch result {
					case .success(let image):
						DispatchQueue.main.async { [weak self] in
							self?.add(image)
						}
					case .failure:
						// fail silently
						break
					}
				}
			}

			if favoritesController?.find(id: eventVM.model.id) ?? false {
				showFavorite(eventVM)
			}

		}
	}

	func add(_ image: UIImage) {
		let imageView = UIImageView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 75.0, height: 75.0))
		imageView.clipsToBounds = true
		imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		imageView.image = image.resizeImage(to: 75.0)
		imageView.layer.cornerRadius = 8.0
		outerStackView.insertArrangedSubview(imageView, at: 0)

		outerStackView.spacing = 10
	}

	func showFavorite(_ eventVM: EventViewModel) {
		let favImage = eventVM.favoriteImage
		let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: favImage.size.width, height: favImage.size.height))
		imageV.tag = App.favoriteIndicatorTag
		imageV.tintColor = eventVM.favoriteColor
		imageV.image = favImage
		addSubview(imageV)
		imageV.leadingAnchor.constraint(equalTo: outerStackView.leadingAnchor).isActive = true
		imageV.topAnchor.constraint(equalTo: outerStackView.topAnchor).isActive = true
	}

	override func prepareForReuse() {
		outerStackView.spacing = 0

		// Remove the photo
		outerStackView.arrangedSubviews.compactMap { (view) -> UIImageView? in
			view as? UIImageView
		}.forEach { (image) in
			image.removeFromSuperview()
			outerStackView.removeArrangedSubview(image)
		}

		location.text = ""
		schedule.text = ""

		// Make sure favorite image is removed
		subviews.filter {
			guard let view = $0 as? UIImageView, view.tag == App.favoriteIndicatorTag else { return false }
			return true
		}.forEach { (favorite) in
			favorite.removeFromSuperview()
		}

	}
}
