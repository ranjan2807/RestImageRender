//
//  ImageDownloader.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift


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
	
	/// shared instance for image downloader class
	static let shared = ImageLoader()

	/// Make constructor private
	private init () {}

	/// Starts retreiving of image data from a specific url
	/// - Parameter url: url of image
	func retreiveImage(_ url: String) -> Observable<Data> {
		/// Checks if image is available in local
		/// if yes, then go for local cache
		// if no, go for remote downloading of image
		var clientType: String

		if FileOperations.checkFileIsAvailable(remoteUrl: url) {
			clientType = "rir.App.Service.ImageProcessStrategy.cache"
		} else {
			clientType = "rir.App.Service.ImageProcessStrategy.rest"
		}

		let client = AppContainer.shared
			.resolve(ImageProcessStrategyProtocol.self,
									   name: clientType)!

		/// Start image fetcher using a specific client type
		let fetcher = ImageFetcherStrategy(url: url, client: client)
		return fetcher.loadImage()
	}
}
