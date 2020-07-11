//
//  ImageDetailViewModel.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift

protocol ImageDetailViewModelProtocol {
	/// calls up when view model is initiated, to ensure view model configuration
	func initialize()

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

	/// Calls up when this view controller object deallocates
	deinit { print("\(type(of: self)) dealloced ......") }
}

extension ImageDetailViewModel: ImageDetailViewModelProtocol {
	/// calls up when view model is initiated, to ensure view model configuration
	func initialize() { }

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
