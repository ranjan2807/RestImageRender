//
//  CacheClient.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift

struct CacheClient: ImageProcessStrategyProtocol {

	func fetchImage(url: String) -> Observable<Data> {
		return Observable.create { observer in

			DispatchQueue.global().async {

				if let data = FileOperations.fileDataFor(remoteUrl: url) {
					observer.onNext(data)
					observer.onCompleted()
				} else {
					observer.onError(RIRError.factory.customError(domain: "Error retreiving data from local file"))
				}
			}
			return Disposables.create()
		}
	}
}
