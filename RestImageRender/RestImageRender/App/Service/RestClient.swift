//
//  RestClient.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol RestClientProtocol {
	func fetchData (url: String) -> Observable<AppData>
}

struct RestClient: RestClientProtocol, ImageProcessStrategyProtocol {

	func fetchData (url: String) -> Observable<AppData> {
		return Observable.create { observer in

			if !NetworkReachabilityManager()!.isReachable {
				observer.onError(RIRError.factory.noNetworkError())
				return Disposables.create ()
			}

			DispatchQueue.global().async {
				AF.request(
					url
				).validate()
					.responseJSON { response in

						// check response object
						guard let responseTemp = response.response else {
							observer.onError(response.error!)
							return
						}

						// check status code
						if responseTemp.statusCode < 200,
							responseTemp.statusCode > 300 {
							observer.onError(response.error!)
							return
						}

						// check response data
						guard let data = response.data else {
							observer.onError(response.error!)
							return
						}

						let stringValue = String(decoding: data, as: UTF8.self)
						let dataTemp = Data(stringValue.utf8)

						do {
							let appData = try JSONDecoder().decode(
								AppData.self,
								from: dataTemp)
							observer.onNext(appData)
							observer.onCompleted()

						} catch {
							observer.onError(error)
						}
				}
			}

			return Disposables.create ()
		}
	}

	func fetchImage (url: String) -> Observable<Data> {
		return Observable.create { observer in

			DispatchQueue.global().async {
				AF.download(url).responseData { (response) in

					print(response.fileURL!)

					// check response object
					guard let responseTemp = response.response else {
						observer.onError(response.error!)
						return
					}

					// check status code
					if responseTemp.statusCode < 200,
						responseTemp.statusCode > 300 {
						observer.onError(response.error!)
						return
					}

					// check file url is available
					guard let fileUrl = response.fileURL else {
						observer.onError(response.error!)
						return
					}

					do {
						let data = try Data(contentsOf: fileUrl)

						DispatchQueue.global().async {
							FileOperations.saveFileForUrl(remoteUrl: url, fileData: data)
						}

						// got the image data
						observer.onNext(data)
						observer.onCompleted()
					} catch {
						observer.onError(response.error!)
						return
					}

					DispatchQueue.global().async {
						// space management
						do {
							try FileManager.default.removeItem(at: fileUrl)
						} catch {
							print("deleted successfully --> \(fileUrl.absoluteString)")
						}

					}
				}
			}

			return Disposables.create()
		}
	}
}
