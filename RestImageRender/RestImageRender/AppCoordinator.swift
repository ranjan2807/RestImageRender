//
//  AppCoordinator.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import UIKit

/// Coordinator base protocol
protocol Coordinator: class {

	/// Child coordinator which each coordinators spawns
    var childCoordinators: [Coordinator] {get set}

	/// Starts the coordinator
    func start()

	/// Helps in deallocating the coordinator
    func finish()
}

extension Coordinator {

	/// Retain the child coordinators in child coordinator array
	/// - Parameter coordinator: child coordinator instance
    func store(coordinator: Coordinator) {
		childCoordinators.append(coordinator)
    }

	/// Release the child coordinators from child coordinator array
	/// - Parameter coordinator: child coordinator instance
    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

/// Application main coordinator instantiated by App Delegate class
final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

	/// Holds the app delegate window
    private let window: UIWindow?

	/// Holds app root navigation controller
    lazy private var rootViewController: UINavigationController? = UINavigationController()

	/// Designated constructor iniating coordinator with app delegate window instance
	/// - Parameter window: app delegate window injected
    init(window: UIWindow?) {
        self.window = window
    }

	/// Starts the coordinator
    func start() {
        guard let window = window else { return}

		// set current coordinator navigation controller as windows root view controller
        window.rootViewController = rootViewController
		// display the navigation controller
        window.makeKeyAndVisible()

		// open the image list screen by initiating image list coordinator
        self.openImageList()
    }

    func finish() {
        // call back to parent coordinator to remove self
    }
}

extension AppCoordinator {

	/// open the image list screen by initiating image list coordinator
    func openImageList() {
		// Get the image list coordinator instance and start the coordinator
		guard let rootViewController = self.rootViewController,
			let coordinator = AppResolver
			.resolve(Coordinator.self,
					 name: "rir.AppCoordinator.ImageListCoordinator",
					 argument: rootViewController) else { return }
        coordinator.start()

		// Retain the coordinator as child of app coordinator
        store(coordinator: coordinator)
    }
}
