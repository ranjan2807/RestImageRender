//
//  ImageViewData.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

struct ImageViewData {

	private let obj: ImageDetail?

	private let restClient: RestClientProtocol?

	init( img: ImageDetail,
		  restClient: RestClientProtocol ) {
		obj = img
		self.restClient = restClient
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
		return Observable.create { observer in

			guard let urlStr = self.obj?.imgUrl else {
				observer.onCompleted()
				return Disposables.create()
			}

			return (self.restClient?.downloadImage(url: urlStr)
				.subscribe(onNext: { (imageData) in
					if let img = UIImage(data: imageData) {
						observer.onNext(img)
					}
					observer.onCompleted()
				},
						   onError: { (_) in
							observer.onCompleted()

				}))!

			//			guard let url = URL.init(string: urlStr) else {
			//				observer.onCompleted()
			//				return Disposables.create()
			//			}
			//
			//			let resource = ImageResource(downloadURL: url)
			//
			//			KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
			//				switch result {
			//				case .success(let value):
			//					observer.onNext(value.image)
			//				case .failure(let error):
			//					print(error)
			//				}
			//
			//				observer.onCompleted()
			//			}
		}
	}

}
