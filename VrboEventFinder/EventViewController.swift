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
	var favoritesController: FavoritesController?
	var delegate: FavoritesDelegate?

	@IBAction func favoriteClicked(_ sender: UIBarButtonItem) {
		guard let favoritesController = favoritesController, let eventVM = eventVM else { return }

		favoritesController.toggle(id: eventVM.model.id)
		favoriteButton.tintColor = eventVM.favoriteColor

		delegate?.update(event: eventVM)
	}

	enum EventTableRows: Int, CaseIterable {
		case photo = 0
		case schedule
		case location
	}

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var favoriteButton: UIBarButtonItem!

	var eventVM: EventViewModel?
	var photo: UIImage?

	override func viewDidLoad() {
		super.viewDidLoad()

		favoriteButton.tintColor = UIColor(named: "favoriteNot")

		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()

		tableView.register(UINib(nibName: "EventDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "photo")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let eventVM = eventVM {
			favoriteButton.tintColor = eventVM.favoriteColor
		}

	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		if let cell = tableView.cellForRow(at: IndexPath(row: EventTableRows(rawValue: 0)?.rawValue ?? 0, section: 0)) as? EventDetailTableViewCell {
			cell.imageV.image = cell.imageV.image?.resizeImage(to: view.frame.size.width)
		}
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadRows(at: [IndexPath(row: EventTableRows(rawValue: 0)?.rawValue ?? 0, section: 0)], with: .fade)
		}
	}

	func add(_ image: UIImage, to cell: EventDetailTableViewCell) {
		cell.imageV.image = image.resizeImage(to: view.frame.size.width - 2*20)
		cell.layer.cornerRadius = 8.0
		print("\(#function.split(separator: "/").last ?? "n/a")")
	}

	func fetchImage(to cell: EventDetailTableViewCell) {
		guard photo == nil, let eventVM = eventVM, let photoFile = eventVM.largePhotoFile
		else {
			if let photo = photo {
				add(photo, to: cell)
			}
			return
		}

		let spinner = addSpinner(to: view)
		eventsService?.fetchImage(photoFile, handler: { [weak self] (result) in
			spinner.removeFromSuperview()
			switch result {
			case .success(let photoResult):
				DispatchQueue.main.async { [weak self] in
					self?.photo = photoResult
					self?.add(photoResult, to: cell)
					self?.tableView.reloadRows(at: [IndexPath(row: EventTableRows(rawValue: 0)?.rawValue ?? 0, section: 0)], with: .fade)
				}
			case .failure:
				break
			}
		})
	}
}

extension EventViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		EventTableRows.allCases.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell?
		
		switch EventTableRows(rawValue: indexPath.row) {
		case .photo:
			cell = tableView.dequeueReusableCell(withIdentifier: "photo") as? EventDetailTableViewCell
			fetchImage(to: cell as! EventDetailTableViewCell)
		case .schedule:
			cell = tableView.dequeueReusableCell(withIdentifier: "info")
			cell?.textLabel?.text = eventVM?.schedule
		case .location:
			cell = tableView.dequeueReusableCell(withIdentifier: "info")
			cell?.textLabel?.text = eventVM?.location

		default:
			break
		}

		return cell ?? UITableViewCell()
	}
}
