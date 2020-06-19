//
//  Performer.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import Foundation

struct Performer: Decodable {
	let id: Int?
	let image: String?
	let images: Dictionary<String, String>?
}
