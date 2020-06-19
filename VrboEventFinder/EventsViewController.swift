//
//  MasterViewController.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import UIKit

class EventsViewController: UITableViewController {
	var eventsService: EventsService?
	let searchBar = UISearchBar()
	var timer: Timer?

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
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	func updateEventsList(query: String) {
		let activitySpinner = addSpinner(to: view)

		eventsService?.fetchEvents(query, handler: { [weak self] (result) in
			activitySpinner.removeFromSuperview()

			switch result {
			case .success(let eventsResult):
				self?.events = eventsResult.events.compactMap {
					EventViewModel(model: $0)
				}
			case .failure:
				// TODO: notify user something went wrong
				break
			}
		})
	}

	func addSpinner(to view: UIView) -> UIActivityIndicatorView {
		let activitySpinner = UIActivityIndicatorView(style: .large)
		view.addSubview(activitySpinner)
		activitySpinner.translatesAutoresizingMaskIntoConstraints = false
		activitySpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		activitySpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		activitySpinner.startAnimating()
		return activitySpinner
	}


	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = tableView.indexPathForSelectedRow {
		        let controller = (segue.destination as! UINavigationController).topViewController as! EventViewController
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		        eventViewController = controller
		    }
		}
	}
}

extension EventsViewController {
	func setupTableView() {
		tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "event")
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44.0
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return events.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// TODO: Configure an empty cell to warn user something went wrong
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as? EventTableViewCell
			else { return UITableViewCell() }

		let eventVM = events[indexPath.row]
		cell.name.text 		= eventVM.name
		cell.location.text 	= eventVM.location
		cell.schedule.text 	= eventVM.schedule

		if let imageURL = eventVM.thumbnailFile {
			eventsService?.fetchImage(imageURL) { result in
				switch result {
				case .success(let image):
					DispatchQueue.main.async { [weak self] in
						cell.add(image)
					}
				case .failure:
					// TODO: error handling
					break
				}
			}
		}

		return cell
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

		timer = Timer.scheduledTimer(withTimeInterval: App.keyStrokeDelay, repeats: false, block: { [weak self] _ in //(Timer) in
			print("\(#function):\t searchText = \(searchText)")
			self?.updateEventsList(query: searchText)
		})
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		timer?.invalidate()
	}
}

extension EventsViewController {
	override var prefersStatusBarHidden: Bool {
	  return true
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
