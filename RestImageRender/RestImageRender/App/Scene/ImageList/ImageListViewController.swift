//
//  ImageListViewController.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class ImageListViewController: UIViewController {

    var viewModel: ImageListViewModelProtocol?

    lazy private var disposeBag = DisposeBag()

    private var collectionView: UICollectionView? = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        var collectionViewTemp = UICollectionView(frame: CGRect(),
                                                  collectionViewLayout: layout)
        collectionViewTemp.collectionViewLayout = layout
        collectionViewTemp.backgroundColor = RIRColors.background
        collectionViewTemp.translatesAutoresizingMaskIntoConstraints = false

        collectionViewTemp.register(ImageCollectionViewCell.self,
                                 forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)

        return collectionViewTemp
    } ()

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = RIRColors.background

        // add collection view
        // in the current screen
        addCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.prefersLargeTitles = true

        // bind collection view with the
        // image list data of viewModel
        bindView ()
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
                cellTemp.imgView?.image = UIImage(named: "placeholder")

                if let strURL = data.imgUrl {
                    let url = URL(string: strURL)
                    cellTemp.imgView?.kf.setImage(
                        with: url,
                        placeholder: UIImage(named: "placeholder")
                    )
                }

        }.disposed(by: disposeBag)

    }

    func addLayoutConstraint() {
        let views: [String: Any] = [
            "collectionView": collectionView!
        ]

        var allConstraints: [NSLayoutConstraint] = []

        let collectionHorizontalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-[collectionView]-|",
        metrics: nil,
        views: views)
        allConstraints += collectionHorizontalConstraints

        let collectionVerticalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-[collectionView]-|",
        metrics: nil,
        views: views)
        allConstraints += collectionVerticalConstraints

        NSLayoutConstraint.activate(allConstraints)
    }

    func addCollectionView() {
        if let layoutTemp = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let screenSize = self.view.bounds.size
            let screenWidth = screenSize.width < screenSize.height ? screenSize.width : screenSize.height
            var cellwidth = 0.0

            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                // It's an iPhone
                cellwidth = Double((screenWidth - (5*10))/2)
            case .pad:
                // It's an iPad (or macOS Catalyst)
                cellwidth = Double((screenWidth - (3*10))/4)
            default:
                cellwidth = Double((screenWidth - (5*10))/2)
            }

            layoutTemp.itemSize = CGSize(width: cellwidth, height: cellwidth)
        }

        self.view.addSubview(collectionView!)
    }

}
