//
//  ImageListCoordinator.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

/// Coordinator class for image list view controller responsible for navigation (in future)
///	and depencency injections of various dependencies of the view controller
final class ImageListCoordinator {
	/// To hold child oordinator, spawn by current coordinator
    var childCoordinators: [Coordinator] = []

	/// Hold navigation controller of current view controller
    private weak var navigationController: UINavigationController?

	private lazy var disposeBag = DisposeBag()

	/// subject to notify screen removal
	private lazy var subjectRemoval = PublishSubject<Coordinator>()

	/// View controller managed by current coordinator
	lazy private var viewModel = AppResolver
		.resolve (ImageListViewModelType.self,
				  name: "rir.App.Scene.ImageList.ImageListViewModel")

	/// Designated constructor for coordinator class
	/// - Parameter navigationController: Navigation controller for coordinator view controller
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension ImageListCoordinator: Coordinator {
	/// Starts coordinator by configuring and opening the view controller by providing relevant dependency injections
	func start() {
		guard let navigationController = self.navigationController,
			let viewModel = viewModel,
			let viewController = AppResolver
				.resolve(ImageListViewControllerProtocol.self,
						 name: "rir.App.Scene.ImageList.ImageListViewController",
						 argument: viewModel) as? ImageListViewController else { return }

		viewModel.initialize()

		// add coordinator view controller into navigation controller to display in UI
		navigationController.viewControllers = [viewController]

		// add navigation handling
		handleNavigations()
	}

	/// provide observable to parent coordinator
	/// to remove its child coordinator
	func finish() -> Observable<Coordinator>? {
		return subjectRemoval.asObservable()
	}
}

extension ImageListCoordinator {

	func handleNavigations() {
		/// navigation handling
		if let viewModel = self.viewModel as? ImageListViewModelNavigationPotocol {

			/// image detail navigation handling
			viewModel.imageDetailObservable
				.observeOn(MainScheduler.instance)
				.subscribe(onNext: { [weak self] (model: ImageViewDataProtocol?) in
					guard let self = self,
						let model = model else { return }
					self.openImageDetail(model: model)
				}).disposed(by: disposeBag)
		}
	}

	/// open image detail screen
	func openImageDetail(model: ImageViewDataProtocol) {
		/// Get the image detail coordinator injected to instantiate
		if let navigationController = self.navigationController,
			let coordinator = AppResolver
			.resolve(ImageDetailCoordinatorProtocol.self,
					 name: "rir.App.Scene.ImageDetail.ImageDetailCoordinator",
					 argument: (nav: navigationController, model: model)) {
			/// start the coordinator
			coordinator.start()

			// Retain the coordinator as child of app coordinator
			store(coordinator: coordinator)

			// update coordinator removal process
			coordinator.finish()?
				.asObservable()
				.subscribe(onNext: { [weak self] childCoordinator in
					guard let self = self else { return }
					self.free(coordinator: childCoordinator)
				}).disposed(by: disposeBag)
		}
	}
}
