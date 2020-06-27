//
//  ImageDownloader.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

protocol ImageProcessStrategyProtocol {
	func  fetchImage (url: String) -> Observable<Data>
}

struct ImageLoader {

	enum ClientType: String {
		case rest = "rest-type"
		case cache = "cache-type"
	}

	static let shared = ImageLoader()

	private var container: Container = {
		var contTemp = Container()

		contTemp.register(ImageProcessStrategyProtocol.self,
						  name: ClientType.rest.rawValue) { _ in
			return RestClient()
		}

		contTemp.register(ImageProcessStrategyProtocol.self,
						  name: ClientType.cache.rawValue) { _ in
			return CacheClient()
		}

		return contTemp
	} ()

	private init () {}

	func retreiveImage(_ url: String) -> Observable<Data> {

		var clientType: ClientType

		if FileOperations.checkFileIsAvailable(remoteUrl: url) {
			clientType = .cache
		} else {
			clientType = .rest
		}

		let client = container.resolve(ImageProcessStrategyProtocol.self,
									   name: clientType.rawValue)!

		let fetcher = ImageFetchStrategy(url: url, client: client)
		return fetcher.loadImage()
	}
}

protocol ImageFetchProtocol {
	init (url: String, client: ImageProcessStrategyProtocol)
	func loadImage() -> Observable<Data>
}

struct ImageFetchStrategy: ImageFetchProtocol {
	private var url: String
	private var client: ImageProcessStrategyProtocol

	init (url: String, client: ImageProcessStrategyProtocol) {
		self.url = url
		self.client = client
	}

	func loadImage() -> Observable<Data> {
		return client.fetchImage(url: url)
	}
}
