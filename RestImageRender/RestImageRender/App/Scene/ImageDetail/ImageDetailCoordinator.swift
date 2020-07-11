//
//  ImageDetailCoordinator.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDetailCoordinatorProtocol: Coordinator {
	var imageModel: ImageViewDataProtocol? { get set }
}

final class ImageDetailCoordinator {
	var childCoordinators: [Coordinator] = []

	var imageModel: ImageViewDataProtocol?

	/// Hold navigation controller of current view controller
	private weak var navigationController: UINavigationController?

	/// Designated constructor for coordinator class
	/// - Parameter navigationController: Navigation controller for coordinator view controller
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
}

extension ImageDetailCoordinator: ImageDetailCoordinatorProtocol {
	func start() {

	}

	func finish() {

	}
}
