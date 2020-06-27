//
//  ImageViewData.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift

struct ImageViewData {

	private let obj: ImageDetail?

	init( img: ImageDetail) {
		obj = img
	}

	var imgTitle: String {
		return obj?.title?
			.trimmingCharacters(
				in: CharacterSet.whitespacesAndNewlines
			) ?? ""
	}

	var imgDesc: String {
		return obj?.imgDesc?
			.trimmingCharacters(
				in: CharacterSet.whitespacesAndNewlines
			) ?? ""
	}

	func loadImage () -> Observable<UIImage> {

		guard let urlStr = self.obj?.imgUrl else {
			return Observable.just(UIImage(named: PLACEHOLDER_IMAGE)!)
		}

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
