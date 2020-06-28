//
//  ImageViewData.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift


/// To abstract model from view controller class, this class wraps the model
/// and presents displayable data from the model to the screen cells
struct ImageViewData {
	/// model of view data
	private let obj: ImageDetail?

	/// Initialize view data by constructor based injection of concern model
	/// - Parameter img: Model class injected
	init( img: ImageDetail) {
		obj = img
	}

	/// returns displayable title from the model
	var imgTitle: String {
		return obj?.title?
			.trimmingCharacters(
				in: CharacterSet.whitespacesAndNewlines
			) ?? ""
	}

	/// returns displayable description from the model
	var imgDesc: String {
		return obj?.imgDesc?
			.trimmingCharacters(
				in: CharacterSet.whitespacesAndNewlines
			) ?? ""
	}

	/// return displayable image observable
	func loadImage () -> Observable<UIImage> {
		// Early exit if image url is corrupted
		guard let urlStr = self.obj?.imgUrl else {
			return Observable.just(UIImage(named: PLACEHOLDER_IMAGE)!)
		}

		// starts downloading of image and later updates the image observable
		return ImageLoader.shared.retreiveImage(urlStr)
			.map { imageData in
				if let img = UIImage(data: imageData) {
					return img
				} else {
					return UIImage(named: PLACEHOLDER_IMAGE)!
				}
		}
	}

}
