//
//  UISPlitViewController+Vrbo.swift
//  VrboEventFinder
//
//  Created by mfa on 6/20/20.
//  Copyright © 2020 Miguel. All rights reserved.
//

import Foundation
import UIKit

extension UISplitViewController {
	open override func awakeFromNib() {
		super.awakeFromNib()

		// Prevent the master from initially collapsing in compact traitcollections on iPads
		preferredDisplayMode = .primaryOverlay
	}
}
