//
//  RepositoryAssembly.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import Swinject

struct RepositoryAssembly: Assembly {

	func assemble(container: Container) {
		// register protocol for view data in table view cells
		container.register(ImageViewDataProtocol.self,
						   name: "rir.App.Scene.ImageList.ImageViewData",
						   factory: { (_, model) in
						ImageViewData(img: model)
		})
	}
}
