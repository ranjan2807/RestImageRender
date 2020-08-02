//
//  ServiceAssembly.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import Swinject

struct ServiceAssembly: Assembly {

	func assemble(container: Container) {
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
	}
}
