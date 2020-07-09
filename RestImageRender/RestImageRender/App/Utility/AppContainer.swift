//
//  AppContainer.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import Swinject

struct AppContainer {

	private init () {}

	static let shared: Container = {
		var container = Container()

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

		// register initialization of RestClient
		container.register (RestClientProtocol.self,
							name: "rir.App.Scene.ImageList.ImageListViewModel") { _ in
								RestClient()
		}
		// register initialization of ImageListViewModel using RestClient
		container.register(ImageListViewModelProtocol.self,
						   name: "rir.App.Scene.ImageList.ImageListViewModel",
						   factory: { resolver in
							ImageListViewModel(
								resolver.resolve(RestClientProtocol.self, name: "rir.App.Scene.ImageList.ImageListViewModel")!
							)
		})

		// register for rest client type dependency
		container.register(ImageProcessStrategyProtocol.self,
						   name: "rir.App.Service.ImageProcessStrategy.rest") { _ in
							return RestClient()
		}

		// register for local cache client type dependency
		container.register(ImageProcessStrategyProtocol.self,
						   name: "rir.App.Service.ImageProcessStrategy.cache") { _ in
							return CacheClient()
		}

		return container
	} ()
}

extension AppContainer {
	static let sharedThing: Container = {
		let container = Container()
		return container
	} ()
}

