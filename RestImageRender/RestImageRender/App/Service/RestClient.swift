//
//  RestClient.swift
//  RestImageRender
//
//  Created by Newpage-iOS on 25/06/20.
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol RestClientProtocol {
	func fetchData (url: String) -> Observable<AppData>
}

struct RestClient: RestClientProtocol {

	func fetchData (url: String) -> Observable<AppData> {
		return Observable.create { observer in

			if !NetworkReachabilityManager()!.isReachable {
				//observer.onError("")
				observer.onCompleted()
				return Disposables.create ()
			}

			AF.request(
				url
			).validate()
				.responseJSON { response in

					// check response object
					guard let responseTemp = response.response else {
						observer.onError(response.error!)
						observer.onCompleted()
						return
					}

					// check status code
					if responseTemp.statusCode < 200,
						responseTemp.statusCode > 300 {
						observer.onError(response.error!)
						observer.onCompleted()
						return
					}

					// check response data
					guard let data = response.data else {
						observer.onError(response.error!)
						observer.onCompleted()
						return
					}

					let stringValue = String(decoding: data, as: UTF8.self)
					let dataTemp = Data(stringValue.utf8)

					do {
						let appData = try JSONDecoder().decode(
							AppData.self,
							from: dataTemp)
						observer.onNext(appData)

					} catch {
						observer.onError(error)
					}

					observer.onCompleted()
			}

			return Disposables.create ()
		}
	}
}
