//
//  EventsService.swift
//  VrboEventFinder
//
//  Created by mfa on 6/19/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias EventsResult = Result<Events, Error>
typealias ImageResult = Result<UIImage, Error>

enum ServicesErrors: Error {
	case pathNotFound
	case dataError
}

class EventsService {
	let services: Services
	var urlEndpoint: String {
		"\(services.baseURL)\(services.eventsEndpoint)?\(services.clientIdName)=\(services.seatGeekAPIKey)"
	}

	init(services: Services) {
		self.services = services
	}

	func fetchEvents(_ query: String, handler: @escaping (EventsResult) -> () ) {
		let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed) ?? ""
		let urlString = "\(urlEndpoint)&q=\(String(describing: queryEncoded))"

		guard let url = URL(string: urlString) else {
			handler( EventsResult.failure(ServicesErrors.pathNotFound)  )
			return
		}

		AF.request(url)
			.validate(statusCode: 200..<300)
			.responseJSON { response in
				switch response.result {
				case .success:
					if let data = response.data, let events = try? JSONDecoder().decode(Events.self, from: data) {
						handler(EventsResult.success(events))
					}
				case .failure:
					handler(EventsResult.failure(ServicesErrors.dataError))
				}
		}

	}

	func fetchImage(_ imageURL: String, handler: @escaping (ImageResult) -> () ) {
		guard let url = URL.init(string: imageURL)
		else {
			handler( ImageResult.failure(ServicesErrors.dataError) )
			return
		}

		AF.request(url)
			.validate(statusCode: 200..<300)
			.responseData { response in
				switch response.result {
				case .success:
					if let data = response.data, let image = UIImage(data: data) {
						handler(ImageResult.success(image))
					}
				case .failure:
					handler(ImageResult.failure(ServicesErrors.dataError))
				}
		}

	}
}
