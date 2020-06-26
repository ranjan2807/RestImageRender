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
    var titleObservable: Observable<String> { get }
    var imagesObservable: Observable<[ImageDetail]> { get }
    var loaderObservable: Observable<Bool> { get }
    func initialize()
    func loadData ()
}

final class ImageListViewModel: ImageListViewModelProtocol {

    private let subjectTitle = BehaviorRelay<String>(value: "")
    private let subjectImages = BehaviorRelay<[ImageDetail]>(value: [])
    private let subjectLoader = BehaviorRelay<Bool>(value: true)

    private let restClient: RestClientProtocol?

    var titleObservable: Observable<String> {
        return subjectTitle.asObservable()
    }

    var imagesObservable: Observable<[ImageDetail]> {
        return subjectImages.asObservable()
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

        client.loadData { [weak self] (data) in
            self?.subjectTitle.accept(data.title ?? "")
            self?.subjectImages.accept(data.items ?? [])

            // stop loader
            self?.subjectLoader.accept(false)
        }
    }
}
