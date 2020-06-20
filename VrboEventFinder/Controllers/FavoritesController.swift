//
//  FavoritesController.swift
//  VrboEventFinder
//
//  Created by mfa on 6/20/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import Foundation

/**
*	Manage list of favorite events
*/
class FavoritesController {
	let userDefaults = UserDefaults.standard

	var favoritesList: [Int] {
		get { return userDefaults.value(forKey: App.favoritesList) as? [Int] ?? [] }

		set {
			userDefaults.set(newValue, forKey: App.favoritesList)
			userDefaults.synchronize()
		}
	}

	func add(id: Int?, to favorites: [Int]?) {
		guard let id = id, var favorites = favorites else { return }
		if find(id: id, in: favorites) == nil {
			favorites.append(id)
		}
		favoritesList = favorites
	}

	func remove(id: Int?, from favorites: [Int]?) {
		guard let id = id, var favorites = favorites else { return }
		if let idx = find(id: id, in: favorites) {
			favorites.remove(at: idx)
		}
		favoritesList = favorites
	}

	func toggle(id: Int?) {
		guard let id = id else { return }
		let favorites = favoritesList
		if let idx = find(id: id, in: favorites) {
			remove(id: favorites[idx], from: favorites)
		} else {
			add(id: id, to: favorites)
		}
	}

	func find(id: Int?) -> Bool {
		guard let id = id else { return false }
		return find(id: id, in: favoritesList) != nil
	}

	func find(id: Int?, in favorites: [Int]?) -> Int? {
		guard let id = id, let favorites = favorites else { return nil }
		return favorites.firstIndex { $0 == id }
	}
}
