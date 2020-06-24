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

    weak var navigationController: UINavigationController?

    lazy private var viewController = ImageListViewController()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if let navigationController = self.navigationController {
            navigationController.viewControllers = [viewController]
        }
    }

    func finish() {

    }

}
