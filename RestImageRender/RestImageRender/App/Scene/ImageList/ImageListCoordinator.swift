//
//  ImageListCoordinator.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import UIKit

/// Coordinator class for image list view controller responsible for navigation (in future)
///	and depencency injections of various dependencies of the view controller
final class ImageListCoordinator: Coordinator {
	/// To hold child oordinator, spawn by current coordinator
    var childCoordinators: [Coordinator]?

	/// Hold navigation controller of current view controller
    private weak var navigationController: UINavigationController?

	/// View controller managed by current coordinator
    lazy private var viewController = ImageListViewController()

	/// Designated constructor for coordinator class
	/// - Parameter navigationController: Navigation controller for coordinator view controller
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

	/// Starts coordinator by configuring and opening the view controller by providing relevant dependency injections
    func start() {
        guard let navigationController = self.navigationController else { return }

		if let viewModel = AppContainer.shared
			.resolve (ImageListViewModelProtocol.self,
					  name: "rir.App.Scene.ImageList.ImageListViewModel") as? ImageListViewModelType {
			self.viewController.viewModel = viewModel
            self.viewController.viewModel?.initialize()
        }

		// add coordinator view controller into navigation controller to display in UI
        navigationController.viewControllers = [viewController]
    }

	/// Not used, will be use to safely remove the current screen
    func finish() { }

}
