//
//  ImageListCoordinator.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import UIKit
import Swinject

/// Coordinator class for image list view controller responsible for navigation (in future)
///	and depencency injections of various dependencies of the view controller
final class ImageListCoordinator: Coordinator {
	/// To hold child oordinator, spawn by current coordinator
    var childCoordinators: [Coordinator]?

	/// Hold navigation controller of current view controller
    private weak var navigationController: UINavigationController?

	/// View controller managed by current coordinator
    lazy private var viewController = ImageListViewController()

	/// Container which ensures safe dependency initialization and reponsible to configure them
    lazy private var container: Container = {
        let contTemp = Container()
		// register initialization of RestClient
        contTemp.register (RestClientProtocol.self) { _ in
            RestClient()
        }
		// register initialization of ImageListViewModel using RestClient
        contTemp.register(ImageListViewModelProtocol.self) { resolver in
            ImageListViewModel(
                resolver.resolve(RestClientProtocol.self)!
            )
        }

        return contTemp
    } ()

	/// Designated constructor for coordinator class
	/// - Parameter navigationController: Navigation controller for coordinator view controller
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

	/// Starts coordinator by configuring and opening the view controller by providing relevant dependency injections
    func start() {
        guard let navigationController = self.navigationController else { return }

        if let viewModel = container.resolve (ImageListViewModelProtocol.self) as? ImageListViewModelType {
			self.viewController.viewModel = viewModel
            self.viewController.viewModel?.initialize()
        }

		// add coordinator view controller into navigation controller to display in UI
        navigationController.viewControllers = [viewController]
    }


	/// Not used, will be use to safely remove the current screen
    func finish() { }

}
