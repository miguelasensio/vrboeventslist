//
//  EventViewModel.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import Foundation
import UIKit

struct EventViewModel {
	let model: Event

	var name: String {
		model.title
	}

	var location: String {
		let connector = (model.venue?.city ?? "").count>0 && (model.venue?.state ?? "").count>0 ? ", " : ""
		var location = (model.venue?.city ?? "") + connector + (model.venue?.state ?? "")
		location = location.count>0 ? location : App.unknownLocation
		return location
	}

	var schedule: String {
		guard let datetime_local = model.datetime_local else { return App.unknownDate }
		guard let date = Date.eventDate(from: datetime_local) else { return App.unknownDate}
		return date.eventDate()
	}

	var thumbnailFile: String? {
		model.performers?.first?.image
	}
}
