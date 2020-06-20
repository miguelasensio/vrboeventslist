//
//  Event.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import Foundation
import UIKit

/*
	I think it's safe to assume that some of these fields are optional and some others are not.
		* Eg., All events can be expected to have an ID, a title and a name; so, we'll fail that record if it doesn't
		* However, Url or Venue might be missing entirely or in part
*/
struct Event: Decodable {
	let title: String
	let datetime_local: String?
	let performers: [Performer]?
	let venue: Venue?
	let id: Int
	let url: String?
}
