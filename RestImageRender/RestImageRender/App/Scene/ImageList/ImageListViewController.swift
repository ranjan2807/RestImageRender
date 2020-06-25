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

    private var collectionView: UICollectionView?

    override func loadView() {
        super.loadView()

        addCollectionView()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView ()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addLayoutConstraint()
    }
}

extension ImageListViewController {

    /// Bind view with observables from view model
    func bindView () {
        // bind navigation title
        viewModel?.titleObservable
            .catchErrorJustReturn("")
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)

        // bind collection view
        viewModel?.imagesObservable.bind(to:
        (collectionView?.rx.items(
            cellIdentifier: ImageCollectionViewCell.reuseIdentifier,
            cellType: UICollectionViewCell.self
            ))!) {  _, data, cell in

                guard let cellTemp = cell as? ImageCollectionViewCell else { return }
                cellTemp.lblTitle?.text = data.title ?? ""
                cellTemp.lblDesc?.text = data.imgDesc ?? ""
        }.disposed(by: disposeBag)

    }

    func addLayoutConstraint() {
        let views: [String: Any] = [
          "collectionView": collectionView!
        ]

        var allConstraints: [NSLayoutConstraint] = []

        let collectionHorizontalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-0-[collectionView]-0-|",
        metrics: nil,
        views: views)
        allConstraints += collectionHorizontalConstraints

        let collectionHVerticalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-0-[collectionView]-0-|",
        metrics: nil,
        views: views)
        allConstraints += collectionHVerticalConstraints

        NSLayoutConstraint.activate(allConstraints)
    }

    func addCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 25, bottom: 40, right: 25)
        layout.itemSize = CGSize(width: 170, height: 170)

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = .white
        self.view.addSubview(collectionView!)

        collectionView?.register(ImageCollectionViewCell.self,
                                 forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
    }
}
