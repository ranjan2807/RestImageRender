//
//  CoordinatorAssembly.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import Swinject

struct CoordinatorAssembly: Assembly {

	func assemble(container: Container) {
		// register coordinator dependency to create instance of app coordinator
		container.register(Coordinator.self,
						   name: "rir.AppDelegate.AppCoordinator",
						   factory: { (_, window) in
							AppCoordinator(window: window)
		})

		/// Register Image list coordinator in swinject conatiner
		container.register(Coordinator.self,
						   name: "rir.AppCoordinator.ImageListCoordinator",
						   factory: { (_, navigationController) in
							ImageListCoordinator(navigationController: navigationController)
		})

		/// Register image detail coordinator in swinject container
		container.register(ImageDetailCoordinatorProtocol.self,
						   name: "rir.App.Scene.ImageDetail.ImageDetailCoordinator",
						   factory: { (_, navigationController)  in
							ImageDetailCoordinator(navigationController: navigationController) })
	}
}
