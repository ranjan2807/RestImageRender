//
//  AppCoordinator.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import UIKit
import Swinject

protocol Coordinator: class {
    var childCoordinators: [Coordinator]? {get set}
    func start()
    func finish()
}

extension Coordinator {

    func store(coordinator: Coordinator) {
        childCoordinators?.append(coordinator)
    }

    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators?.filter { $0 !== coordinator }
    }
}

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator]?

    private let window: UIWindow?

    lazy private var rootViewController: UINavigationController? = UINavigationController()

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        guard let window = window else { return}
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        self.openImageList()
    }

    func finish() {
        // call back to parent coordinator to remove self
    }
}

extension AppCoordinator {

    func openImageList() {


    }
}

