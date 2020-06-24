//
//  ImageListViewController.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import UIKit
import RxSwift

class ImageListViewController: UIViewController {

    var viewModel: ImageListViewModelProtocol?

    lazy private var disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView ()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

extension ImageListViewController {

    /// Bind view with observables from view model
    func bindView () {
        // bind navigation title
        viewModel?.titleObservable
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        
        // bind collection view 
    }
}
