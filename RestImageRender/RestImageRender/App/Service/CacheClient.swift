//
//  CacheClient.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift


/// Caching service
struct CacheClient: ImageProcessStrategyProtocol {

	/// fetch image from image folder of document directory
	/// - Parameter url: remote url for referncing the local image name
	func fetchImage(url: String) -> Observable<Data> {
		return Observable.create { observer in

			DispatchQueue.global().async {

				/// retrieve cached file from document directory
				if let data = FileOperations.fileDataFor(remoteUrl: url) {
					// forward the data using observation and then finish up the observable
					observer.onNext(data)
					observer.onCompleted()
				} else {
					// forward the custom error.
					observer.onError(RIRError.factory
						.customError(
							message: "Error retreiving data from local file".localized
						)
					)
				}
			}
			return Disposables.create()
		}
	}
}
