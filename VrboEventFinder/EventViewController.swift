//
//  DetailViewController.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
	var eventsService: EventsService?

	@IBOutlet weak var photo: UIImageView!
	@IBOutlet weak var schedule: UILabel!
	@IBOutlet weak var location: UILabel!

	var event: EventViewModel? {
		didSet {
			configureView()
		}
	}

	func configureView() {
		if let event = event, let schedule = schedule, let location = location {
			if let photoFile = event.largePhotoFile {
				getImage(photoFile)
			}
			schedule.text = event.schedule
			location.text = event.location

			navigationItem.title = nil
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureView()
	}

	func getImage(_ file: String) {
		eventsService?.fetchImage(file, handler: { [weak self] (result) in
			switch result {
			case .success(let photoResult):
				guard let width = self?.view.frame.size.width else { return }
				self?.photo.image = photoResult.resizeImage(to: width - 2*20)
				self?.photo.layer.cornerRadius = 8.0
			case .failure:
				break
			}
		})
	}
}

