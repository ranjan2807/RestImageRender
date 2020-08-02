//
//  ImageDetailCoordinator.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol ImageDetailCoordinatorProtocol: Coordinator {
	/// model detail to display
	var imageModel: ImageViewDataProtocol? { get set }
}

final class ImageDetailCoordinator {
	var childCoordinators: [Coordinator] = []

	/// model detail to display
	var imageModel: ImageViewDataProtocol?

	private lazy var disposeBag = DisposeBag()

	/// subject to notify screen removal
	private lazy var subjectRemoval = PublishSubject<Coordinator>()

	/// holds view model
	lazy private var viewModel = AppResolver
		.resolve(ImageDetailViewModelProtocol.self,
				 name: "rir.App.Scene.ImageDetail.ImageDetailViewModel")

	/// Hold navigation controller of current view controller
	private weak var navigationController: UINavigationController?

	/// Designated constructor for coordinator class
	/// - Parameter navigationController: Navigation controller for coordinator view controller
	init(navigationController: UINavigationController, model: ImageViewDataProtocol) {
		self.navigationController = navigationController
		self.imageModel = model
	}

	/// Calls up when this view controller object deallocates
	deinit { print("\(type(of: self)) dealloced ......") }
}

extension ImageDetailCoordinator: ImageDetailCoordinatorProtocol {
	/// Starts coordinator by configuring and opening the view controller by providing relevant dependency injections
	func start() {
		guard let navigationController = self.navigationController,
			let viewModel = self.viewModel,
			let viewController = AppResolver
				.resolve(ImageDetailViewControllerProtocol.self,
						 name: "rir.App.Scene.ImageDetail.ImageDetailViewController",
						 argument: viewModel
			) as? UIViewController,
			let model = self.imageModel else { return }

		viewModel.initialize(model: model)

		// show image detail screen
		navigationController.show(viewController, sender: nil)

		handleViewRemoval ()
	}

	/// provide observable to parent coordinator
	/// to remove its child coordinator
	func finish() -> Observable<Coordinator>? {
		return subjectRemoval.asObservable()
	}
}

// MARK: - MISC
extension ImageDetailCoordinator {
	/// method to handle screen removal safely
	func handleViewRemoval () {
		if let viewModel = self.viewModel as? ImageDetailViewModelNavigationProtocol {
			viewModel.backObservable
				.observeOn(MainScheduler.instance)
				.subscribe(onNext: { [weak self] _ in
					// update removal subject
					guard let self = self else { return }
					self.subjectRemoval.onNext(self)
				}).disposed(by: disposeBag)
		}
	}
}
