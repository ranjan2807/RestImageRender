//
//  ImageListCoordinator.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import UIKit
import Swinject

final class ImageListCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?

    private weak var navigationController: UINavigationController?

    lazy private var viewController = ImageListViewController()

    lazy private var container: Container = {
        let contTemp = Container()

        contTemp.register (RestClientProtocol.self) { _ in
            RestClient()
        }

        contTemp.register(ImageListViewModelProtocol.self) { resolver in
            ImageListViewModel(
                resolver.resolve(RestClientProtocol.self)!
            )
        }

        return contTemp
    } ()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let navigationController = self.navigationController else { return }

        if let viewModel = container.resolve(ImageListViewModelProtocol.self) {
            self.viewController.viewModel = viewModel
            self.viewController.viewModel?.initialize()
        }

        navigationController.viewControllers = [viewController]
    }

    func finish() {

    }

}
