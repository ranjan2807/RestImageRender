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

    func initialize()
}

final class ImageListViewModel: ImageListViewModelProtocol {

    private let subject = BehaviorRelay<String>(value: "")
    private let restClient: RestClientProtocol?

    var titleObservable: Observable<String> {
        return subject.asObservable()
    }

    init(_ restClient: RestClientProtocol) {
        self.restClient = restClient
    }

    func initialize() {

        guard let client = self.restClient else { return }
        client.loadData { [unowned self] (data) in
            self.subject.accept(data.title ?? "")
        }
    }
}
