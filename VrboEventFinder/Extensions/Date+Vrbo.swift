//
//  Date+Vrbo.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import Foundation

extension Date {
	func eventDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = App.toStringDateFormat
		return dateFormatter.string(from: self)
	}

	static func eventDate(from dateString: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = App.fromStringDateFormat
		if let date = dateFormatter.date(from: dateString) {
			return date
		} else {
			return nil
		}
	}
}
