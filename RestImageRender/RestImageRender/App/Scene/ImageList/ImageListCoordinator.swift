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

        contTemp.register(ImageListViewModelProtocol.self) { _ in
            ImageListViewModel()
        }

        return contTemp
    } ()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if let navigationController = self.navigationController {
            self.viewController.viewModel = container.resolve(ImageListViewModelProtocol.self)
            self.viewController.viewModel?.initialize()

            navigationController.viewControllers = [viewController]
        }
    }

    func finish() {

    }

}
