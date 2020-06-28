//
//  ImageDownloader.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

/// Strategy Protocol responsble for image fetching from url
protocol ImageProcessStrategyProtocol {

	/// method to fetch image data
	/// - Parameter url: remote url of image data
	func  fetchImage (url: String) -> Observable<Data>
}

/// Protocol for Image fetcher which uses a specific ImageProcessStrategyProtocol client
/// object to return back observable of image retreived either from remote or local.
/// Client objects contains a specific logic which aims at retreiving image data
/// This client object is dynamically injected using constructor base injection
protocol ImageFetcherProtocol {

	/// Designated contruction for image fetcher class which fetches
	/// image from a given url using a specific logic defined by a dynamic client
	/// - Parameters:
	///   - url: remote url of image
	///   - client: client containing a specific logic to retrieve data
	init (url: String, client: ImageProcessStrategyProtocol)

	/// Starts loading of image from the given remote url using a specific client logic
	func loadImage() -> Observable<Data>
}

/// Class which implements ImageFetcherProtocol and aims at retreiving
/// image from a given url and a dynamic client logic (Strategy design pattern)
struct ImageFetcherStrategy: ImageFetcherProtocol {
	// hold remote url
	private var url: String
	// hold a specific client logic
	private var client: ImageProcessStrategyProtocol

	init (url: String, client: ImageProcessStrategyProtocol) {
		self.url = url
		self.client = client
	}

	func loadImage() -> Observable<Data> {
		return client.fetchImage(url: url)
	}
}

/// Main class responsible for proving image
struct ImageLoader {

	/// Enum for image fetcher client type
	enum ClientType: String {
		case rest = "rest-type" // rest api client type
		case cache = "cache-type" // local cache client type
	}

	/// shared instance for image downloader class
	static let shared = ImageLoader()

	/// Swinject container for handling strategy client dependency injection
	private var container: Container = {
		var contTemp = Container()

		// register for rest client type dependency
		contTemp.register(ImageProcessStrategyProtocol.self,
						  name: ClientType.rest.rawValue) { _ in
			return RestClient()
		}

		// register for local cache client type dependency
		contTemp.register(ImageProcessStrategyProtocol.self,
						  name: ClientType.cache.rawValue) { _ in
			return CacheClient()
		}

		return contTemp
	} ()

	/// Make constructor private
	private init () {}

	/// Starts retreiving of image data from a specific url
	/// - Parameter url: url of image
	func retreiveImage(_ url: String) -> Observable<Data> {
		/// Checks if image is available in local
		/// if yes, then go for local cache
		// if no, go for remote downloading of image
		var clientType: ClientType

		if FileOperations.checkFileIsAvailable(remoteUrl: url) {
			clientType = .cache
		} else {
			clientType = .rest
		}

		let client = container.resolve(ImageProcessStrategyProtocol.self,
									   name: clientType.rawValue)!

		/// Start image fetcher using a specific client type
		let fetcher = ImageFetcherStrategy(url: url, client: client)
		return fetcher.loadImage()
	}
}
