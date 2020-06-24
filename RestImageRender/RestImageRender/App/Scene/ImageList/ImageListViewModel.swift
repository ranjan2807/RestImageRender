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

    var titleObservable: Observable<String> {
        return subject.asObservable()
    }

    func initialize() {
        subject.accept("Test")
    }
}
