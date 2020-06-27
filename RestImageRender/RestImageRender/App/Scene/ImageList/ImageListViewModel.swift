//
//  ImageListViewModel.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ImageListViewModelProtocol {
    var titleObservable: Driver<String> { get }
    var imagesObservable: Driver<[ImageViewData]> { get }
    var loaderObservable: Observable<Bool> { get }
    func initialize()
    func loadData ()
}

final class ImageListViewModel: ImageListViewModelProtocol {

    private let subjectTitle = BehaviorRelay<String>(value: "")
    private let subjectImages = BehaviorRelay<[ImageViewData]>(value: [])
    private let subjectLoader = BehaviorRelay<Bool>(value: true)

    private let restClient: RestClientProtocol?

    lazy private var disposeBag = DisposeBag()

    var titleObservable: Driver<String> {
        return subjectTitle.asDriver(onErrorJustReturn: "")
    }

    var imagesObservable: Driver<[ImageViewData]> {
        return subjectImages.asDriver(onErrorJustReturn: [])
    }

    var loaderObservable: Observable<Bool> {
        return subjectLoader.asObservable()
    }

    init(_ restClient: RestClientProtocol) {
        self.restClient = restClient
    }

    func initialize() {
        loadData()
    }
}

extension ImageListViewModel {

    func loadData () {
        guard let client = self.restClient else { return }

        // start loader
        subjectLoader.accept(true)

        // start fetching data from remote
		client.fetchData(url: CONTENT_URL)
            .subscribe(
                onNext: { [weak self] (data) in
                    // update screen
                    self?.updateTitle(title: data.title)
                    self?.updateItems(items: data.items)
                },
                onError: {  (error) in
					print(error)
                },
                onDisposed: { [weak self] in
					// stop loader
					self?.subjectLoader.accept(false)
			})
            .disposed(by: disposeBag)
    }

    fileprivate func updateTitle (title: String?) {
        if let titleTemp = title {
            subjectTitle.accept(titleTemp)
        } else {
            subjectTitle.accept("")
        }
    }

    fileprivate func updateItems (items: [ImageDetail]?) {
        if let itemTemp = items,
		itemTemp.count > 0 {
			let newItems = itemTemp.map { ImageViewData(img: $0,
														restClient: restClient!) }
            subjectImages.accept(newItems)
        } else {
            subjectImages.accept([])
        }

    }
}
