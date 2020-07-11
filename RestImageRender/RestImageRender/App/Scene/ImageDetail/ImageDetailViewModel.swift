//
//  ImageDetailViewModel.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation

protocol ImageDetailViewModelProtocol {
	/// calls up when view model is initiated, to ensure view model configuration
	func initialize()
}

protocol ImageDetailViewModelNavigationProtocol {

}

final class ImageDetailViewModel {

}

extension ImageDetailViewModel: ImageDetailViewModelProtocol {
	/// calls up when view model is initiated, to ensure view model configuration
	func initialize() { }
}
