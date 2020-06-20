//
//  MasterViewController.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import UIKit

protocol FavoritesDelegate {
	func update(event: EventViewModel)
}

class EventsViewController: UIViewController {
	var eventsService: EventsService?
	var favoritesController: FavoritesController?

	let searchBar = UISearchBar()
	var timer: Timer?

	@IBOutlet weak var tableView: UITableView!

	var events = [EventViewModel]() {
		didSet {
			tableView.reloadData()
		}
	}

	var eventViewController: EventViewController? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
		setupSearch()
		updateEventsList(query: "")

		setNeedsStatusBarAppearanceUpdate()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: false)
		}

		navigationController?.navigationBar.barTintColor = UIColor(named: "navBar")
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]

		navigationController?.navigationBar.barStyle = .black

	}

	func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "event")
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44.0
		tableView.tableFooterView = UIView()
	}

	func updateEventsList(query: String) {
		let activitySpinner = addSpinner(to: view)

		eventsService?.fetchEvents(query, handler: { [weak self] (result) in
			activitySpinner.removeFromSuperview()

			switch result {
			case .success(let eventsResult):
				self?.events = eventsResult.events.compactMap {
					EventViewModel(model: $0, favoritesController: self?.favoritesController)
				}
			case .failure:
				// The UI already handles an empty data condition, so user will be aware that events listing is not available.
				// TODO: But we should log an error here for diagnostics
				self?.events = []
			}
		})
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = tableView.indexPathForSelectedRow {
		        let controller = (segue.destination as! UINavigationController).topViewController as! EventViewController
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true

				controller.eventVM = events[indexPath.row]
				controller.eventsService = eventsService
				controller.favoritesController = favoritesController
				controller.delegate = self

				let backItem = UIBarButtonItem()
				backItem.title = events[indexPath.row].name
				navigationItem.backBarButtonItem = backItem

				navigationController?.navigationBar.barTintColor = UIColor.white
				navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
				navigationController?.navigationBar.barStyle = .default
		    }
		}
	}
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("\(#function) \(indexPath)")
		performSegue(withIdentifier: "showDetail", sender: indexPath)
	}

	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		print("\(#function)")
		return true
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return events.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as? EventTableViewCell
		else {
			let cell = UITableViewCell()
			cell.textLabel?.text = "No data currently available for this event."
			return cell
		}

		cell.favoritesController = favoritesController
		cell.eventsService = eventsService
		cell.eventVM = events[indexPath.row]

		return cell
	}

	 func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return events.isEmpty ? "No events available at this time" : ""
	}
}

extension EventsViewController: UISearchBarDelegate {
	func setupSearch() {
		searchBar.delegate = self
		searchBar.showsCancelButton = true

		searchBar.tintColor = UIColor.white
		searchBar.barTintColor = UIColor.white

		searchBar.searchTextField.textColor = UIColor.white
		searchBar.searchTextField.backgroundColor = UIColor(named: "searchBarBackground")

		searchBar.searchTextField.leftView?.tintColor = .white
	
		navigationItem.titleView = searchBar
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		timer?.invalidate()

		timer = Timer.scheduledTimer(withTimeInterval: App.keyStrokeDelay, repeats: false, block: { [weak self] _ in
			print("\(#function):\t searchText = \(searchText)")
			self?.updateEventsList(query: searchText)
		})
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		timer?.invalidate()
		searchBar.endEditing(true)
	}
}

extension EventsViewController: FavoritesDelegate {
	func update(event: EventViewModel) {
		guard let eventIndex = events.firstIndex(where: {$0 == event}),
			let cell = tableView.cellForRow(at: IndexPath(row: eventIndex, section: 0)) as? EventTableViewCell
		else { return }

		cell.subviews.filter {
			guard let view = $0 as? UIImageView, view.tag == App.favoriteIndicatorTag else { return false }
			return true
		}.forEach { (favorite) in
			favorite.removeFromSuperview()
		}

		guard let eventVM = cell.eventVM else { return }
		if eventVM.isFavorite {
			cell.showFavorite(eventVM)
		}
	}
}
