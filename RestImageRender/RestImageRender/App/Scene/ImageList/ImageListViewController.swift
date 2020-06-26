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

    // view model
    var viewModel: ImageListViewModelProtocol?

    // dispose bag for rx elements
    lazy private var disposeBag = DisposeBag()

    // collection view that will load images downloaded
    lazy private var collectionView: UICollectionView? = {
        let collectionViewTemp = UICollectionView(frame: CGRect(),
                                                  collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewTemp.backgroundColor = RIRColors.background
        collectionViewTemp.translatesAutoresizingMaskIntoConstraints = false

        collectionViewTemp.register(ImageCollectionViewCell.self,
                                    forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)

        return collectionViewTemp
    } ()

    // loader view
    lazy private var loaderView: UIActivityIndicatorView? = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.style = .whiteLarge
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.backgroundColor = RIRColors.primary

        return activity
    } ()

    // pull to refresh
    lazy private var refreshCollection: UIRefreshControl? = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")

        return refreshControl
    } ()

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = RIRColors.background

        // add screen views
        addSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.prefersLargeTitles = true

        // bind collection view with the
        // image list data of viewModel
        bindView ()

        // update constraints of
        // all subviews of screen
        addLayoutConstraint()
    }
}

// MARK: - UI RENDER
extension ImageListViewController {

    func addSubviews() {
        // add collection view
        addCollectionView()

        // add loader
        addLoader()

        // add pull to refresh
        addPullToRefresh()
    }

    func addLoader() {
        self.view.addSubview(loaderView!)
        self.view.bringSubviewToFront(loaderView!)
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

            layoutTemp.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            layoutTemp.itemSize = CGSize(width: cellwidth, height: cellwidth)
        }

        self.view.addSubview(collectionView!)
    }

    func addPullToRefresh () {
        refreshCollection!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView!.addSubview(refreshCollection!)
    }

    @objc func refresh () {

        // reload Screen data
        if let viewModel = viewModel {
            viewModel.loadData()
        }

        // hide pull to refresh
        self.perform(#selector(hidePullToRefresh),
                     with: refreshCollection,
                     afterDelay: 2.0)
    }

    @objc func hidePullToRefresh () {
        refreshCollection?.endRefreshing()
    }

}

// MARK: - CONSTRAINTS
extension ImageListViewController {

    // adds contains to different views of screen
    func addLayoutConstraint() {
        let views: [String: Any] = [
            "collectionView": collectionView!,
            "loaderView": loaderView!,
            "superview": self.view!
        ]

        var allConstraints: [NSLayoutConstraint] = []

        // collection horizontal axis constraints
        let collectionHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[collectionView]|",
            metrics: nil,
            views: views)
        allConstraints += collectionHorizontalConstraints

        // collection vertical axis constraints
        let collectionVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[collectionView]|",
            metrics: nil,
            views: views)
        allConstraints += collectionVerticalConstraints

        let loaderVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[superview]-(<=1)-[loaderView(100)]",
            options: .alignAllCenterX,
            metrics: nil,
            views: views)
        allConstraints += loaderVerticalConstraints

        let loaderHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[superview]-(<=1)-[loaderView(100)]",
            options: .alignAllCenterY,
            metrics: nil,
            views: views)
        allConstraints += loaderHorizontalConstraints

        NSLayoutConstraint.activate(allConstraints)
    }
}

// MARK: - VIEW MODEL BINDINGS
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

        // bind loader
        viewModel?.loaderObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] flag in
                if flag {
                    self?.loaderView?.startAnimating()
                } else {
                    self?.loaderView?.stopAnimating()
                }
                }
        ).disposed(by: disposeBag)

    }
}
