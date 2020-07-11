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

	/// model detail to display
	var imageModel: ImageViewDataProtocol?

	/// holds view model
	lazy private var viewModel = AppResolver
		.resolve(ImageDetailViewModelProtocol.self,
				 name: "rir.App.Scene.ImageDetail.ImageDetailViewModel")

	/// Hold navigation controller of current view controller
	private weak var navigationController: UINavigationController?

	/// Designated constructor for coordinator class
	/// - Parameter navigationController: Navigation controller for coordinator view controller
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
}

extension ImageDetailCoordinator: ImageDetailCoordinatorProtocol {
	/// Starts coordinator by configuring and opening the view controller by providing relevant dependency injections
	func start() {
		guard let navigationController = self.navigationController,
			let viewModel = self.viewModel,
			let viewController = AppResolver
				.resolve(ImageDetailViewControllerProtocol.self,
						 name: "rir.App.Scene.ImageDetail.ImageDetailViewController",
						 argument: viewModel
			) as? UIViewController else { return }

		viewModel.initialize()

		// show image detail screen
		navigationController.show(viewController, sender: nil)
	}

	/// Not used, will be use to safely remove the current screen
	func finish() {

	}
}
