//
//  ViewModelAssembly.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import Swinject

struct ViewModelAssembly: Assembly {
	func assemble(container: Container) {
		// register initialization of RestClient
		container.register (RestClientProtocol.self,
							name: "rir.App.Scene.ImageList.ImageListViewModel") { _ in
								RestClient()
		}

		// register initialization of ImageListViewModel using RestClient
		container.register(ImageListViewModelType.self,
						   name: "rir.App.Scene.ImageList.ImageListViewModel",
						   factory: { resolver in
							ImageListViewModel(
								resolver.resolve(RestClientProtocol.self, name: "rir.App.Scene.ImageList.ImageListViewModel")!
							)
		})

		// register initialzation of imageDetailViewModel
		container.register(ImageDetailViewModelProtocol.self,
						   name: "rir.App.Scene.ImageDetail.ImageDetailViewModel",
						   factory: { _ in ImageDetailViewModel() })
	}
}
