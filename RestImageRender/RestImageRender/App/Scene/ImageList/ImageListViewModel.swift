//
//  ImageListViewModel.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Protocol to configure View model
protocol ImageListViewModelProtocol {
	/// calls up when view model is initiated, to ensure view midel configuration
	func initialize()

	/// Implements fetching of facts json from remote
	/// - Parameter forcedReload: if set to true, ensures json as well as images are resets with updated data
	func loadData (forcedReload: Bool)
}

/// Protocol to keeps list of all observables
protocol ImageListViewModelObservableProtocol {
	/// Drives title of screen according to Fetched JSON
	var titleObservable: Driver<String> { get }

	/// Drives forwarding fetched Facts data to image view screen rendering
	var imagesObservable: Driver<[ImageViewData]> { get }

	/// Observable to control animation of loader while JSON file is being fetch from server
	var loaderObservable: Observable<Bool> { get }
}

/// type alias for composition of protocols of View model class
typealias ImageListViewModelType = ImageListViewModelProtocol & ImageListViewModelObservableProtocol

/// View model class for facts list view controller. This class holds the entire business logic
/// implementations of image list screen. This class is injected to image list screen by coordinator
final class ImageListViewModel: ImageListViewModelType {

	/// Observer for control title changes
    private let subjectTitle = BehaviorRelay<String>(value: "")

	/// Observer to control facts data updates
    private let subjectImages = BehaviorRelay<[ImageViewData]>(value: [])

	/// Observer to control loader animation
    private let subjectLoader = BehaviorRelay<Bool>(value: true)

	// Service that helps in making connection to remote
    private let restClient: RestClientProtocol?

	/// Dispose bag for Rx observables to ensure safe deallacation
    lazy private var disposeBag = DisposeBag()

	// Due to implementation of ImageListViewModelObservableProtocol
    var titleObservable: Driver<String> {
        return subjectTitle.asDriver(onErrorJustReturn: "")
    }

    var imagesObservable: Driver<[ImageViewData]> {
        return subjectImages.asDriver(onErrorJustReturn: [])
    }

    var loaderObservable: Observable<Bool> {
        return subjectLoader.asObservable()
    }

	/// Initializes view model class
	/// - Parameter restClient: service for remote connection injected by coordinators
    init(_ restClient: RestClientProtocol) {
        self.restClient = restClient
    }

	// Due to implementation of ImageListViewModelObservableProtocol
    func initialize() {
		// initialize screen title with default title
		subjectTitle.accept("Facts".localized)

		// start fetching data from resmote
        loadData()
    }
}

extension ImageListViewModel {
	// Due to implementation of ImageListViewModelObservableProtocol
	func loadData (forcedReload: Bool = false) {
        guard let client = self.restClient else { return }

        // start loader
		subjectLoader.accept(true)

		// remove all cached image files if needed
		if forcedReload {
			FileOperations.removeALlImageFile()
		}

        // start fetching data from remote
		client.fetchData(url: CONTENT_URL)
			.subscribe(
				onNext: { [weak self] (data) in
					// update screen title
					self?.updateTitle(title: data.title)
					// update collection view items
					self?.updateItems(items: data.items)
				},
				onError: { [weak self] (error) in
					// update screen title
					self?.updateTitle(title: nil)
					// update collection view items
					self?.updateItems(items: nil)
					print(error)
				},
				onDisposed: { [weak self] in
					// stop loader
					self?.subjectLoader.accept(false)
			})
			.disposed(by: disposeBag)
    }

	/// Updates screen title driver which drives updates of title of the screen
	/// - Parameter title: title to update in the screen
    fileprivate func updateTitle (title: String?) {
        if let titleTemp = title {
			// update title from JSON data if valid
            subjectTitle.accept(titleTemp)
        } else {
			// update default title
			subjectTitle.accept("Facts".localized)
        }
    }

	/// Updates screen item observable which drives updation of collection view items
	/// - Parameter items: items to display in collection view
    fileprivate func updateItems (items: [ImageDetail]?) {
        if let itemTemp = items,
		itemTemp.count > 0 {
			/// Transforming Model array into view data array to ensure abstraction
			/// of model using its view data model class, which controls each item rendering in cells
			let newItems = itemTemp.map { ImageViewData(img: $0) }
            subjectImages.accept(newItems)
        } else {
            subjectImages.accept([])
        }

    }
}
