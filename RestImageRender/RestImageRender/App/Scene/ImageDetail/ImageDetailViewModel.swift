//
//  ImageDetailViewModel.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ImageDetailViewModelProtocol {
	/// calls up when view model is initiated, to ensure view model configuration
	func initialize(model: ImageViewDataProtocol)

	/// Drives title of screen
	var titleObservable: Driver<String> { get }

	/// calls up when image detail screen is removed
	func imageDetailScreenRemoved()
}

protocol ImageDetailViewModelNavigationProtocol {
	/// observable for back button event
	var backObservable: Observable<Void> { get }
}

final class ImageDetailViewModel {
	/// subject to control back button navigations
	lazy private var subjectBack = PublishSubject<Void>()

	/// Observer to control image detail title
	private let subjectTitle = BehaviorSubject<String>(value: "Fact".localized)

	/// model detail to display
	private var imageModel: ImageViewDataProtocol?

	/// Calls up when this view controller object deallocates
	deinit { print("\(type(of: self)) dealloced ......") }
}

extension ImageDetailViewModel: ImageDetailViewModelProtocol {
	/// Drives title of screen
	var titleObservable: Driver<String> {
		return subjectTitle.asDriver(onErrorJustReturn: "Fact".localized)
	}

	/// calls up when view model is initiated, to ensure view model configuration
	func initialize(model: ImageViewDataProtocol) {
		self.imageModel = model

		// update screen title
		subjectTitle.onNext(model.imgTitle)
	}

	/// calls up when image detail screen is removed
	func imageDetailScreenRemoved() {
		// push screen removed event
		subjectBack.onNext(())
	}
}

extension ImageDetailViewModel: ImageDetailViewModelNavigationProtocol {
	/// observable for back button event
	var backObservable: Observable<Void> {
		return subjectBack.asObservable()
	}
}
