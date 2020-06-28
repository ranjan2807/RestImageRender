//
//  ImageListViewController.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import UIKit
import RxSwift

/// Screen class for displaying facts list
final class ImageListViewController: UIViewController {

	/// view model
	var viewModel: ImageListViewModelType?

	/// dispose bag for rx elements
	lazy private var disposeBag = DisposeBag()

	/// collection view that will load images downloaded
	lazy private var collectionView: UICollectionView? = {
		let collectionViewTemp = UICollectionView(frame: CGRect(),
												  collectionViewLayout: UICollectionViewFlowLayout())
		collectionViewTemp.backgroundColor = RIRColors.background
		collectionViewTemp.isHidden = false
		collectionViewTemp.translatesAutoresizingMaskIntoConstraints = false

		collectionViewTemp.register(ImageCollectionViewCell.self,
									forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)

		return collectionViewTemp
	} ()

	/// loader view
	lazy private var loaderView: UIActivityIndicatorView? = {
		let activity = UIActivityIndicatorView()
		activity.hidesWhenStopped = true
		activity.style = .whiteLarge
		activity.translatesAutoresizingMaskIntoConstraints = false
		activity.backgroundColor = RIRColors.primary

		return activity
	} ()

	/// pull to refresh
	lazy private var refreshCollection: UIRefreshControl? = {
		let refreshControl = UIRefreshControl()
		refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)

		return refreshControl
	} ()

	// empty screen label
	lazy private var lblEmptyScreen: UILabel? = {
		let lbl = UILabel()
		lbl.text = "No facts found!".localized
		lbl.font = UIFont.boldSystemFont(ofSize: 24)
		lbl.textAlignment = .center
		lbl.textColor = RIRColors.primary
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.numberOfLines = 0
		lbl.isHidden = true
		return lbl
	} ()

	/// Calls up when this view controller object deallocates
	deinit { print("\(type(of: self)) dealloced ......") }

	/// Calls up just after view controller is alloc
	/// ideal time to add UI subviews and UI configurations
	override func loadView() {
		super.loadView()

		// change background color of screen with
		// app scecific background color
		self.view.backgroundColor = RIRColors.background

		// Add refresh button to refresh the data
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Refresh".localized,
			style: .plain,
			target: self,
			action: #selector(refresh))

		// add all screen views
		addSubviews()
	}

	/// Calls up when view controller view loads up
	override func viewDidLoad() {
		super.viewDidLoad()

		// adds large title title with a nice animation
		// while scrolling collection view
		self.navigationController!.navigationBar.prefersLargeTitles = true

		// mechnism to update the facts list
		// whenever app bacome active
		NotificationCenter.default
			.addObserver(self,
						 selector: #selector(refresh),
						 name: UIApplication.didBecomeActiveNotification,
						 object: nil)

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

	/// main method to all subviews of screen
	fileprivate func addSubviews() {
		// add empty data text warning
		addEmptyDataWarning()

		// add collection view
		addCollectionView()

		// add loader
		addLoader()

		// add pull to refresh
		addPullToRefresh()
	}

	/// 1. Adds loader which displays while
	/// app is busy fetching the updated list of facts
	fileprivate func addLoader() {
		self.view.addSubview(loaderView!)

		// To ensure loader appears at the top
		self.view.bringSubviewToFront(loaderView!)
	}

	/// 2. Adds the collection view and configure flow layout
	fileprivate func addCollectionView() {
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

			// gabs to added into collection view edges
			layoutTemp.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
			// sets size each cell
			layoutTemp.itemSize = CGSize(width: cellwidth, height: cellwidth*1.5)
			layoutTemp.minimumLineSpacing = 30 // sets verticle spacing between cells
		}

		self.view.addSubview(collectionView!)
	}

	/// 3. Adds pull to refresh component of collection view
	/// to refresh the data whenever neede
	fileprivate func addPullToRefresh () {
		refreshCollection!.addTarget(self, action: #selector(refresh), for: .valueChanged)
		collectionView!.addSubview(refreshCollection!)
	}

	/// Add empty screen text warning
	fileprivate func addEmptyDataWarning() {
		collectionView?.addSubview(lblEmptyScreen!)
	}
}

// MARK: - CONSTRAINTS
extension ImageListViewController {

	// adds contains to different views of screen
	fileprivate func addLayoutConstraint() {
		let views: [String: Any] = [
			"collectionView": collectionView!,
			"loaderView": loaderView!,
			"superview": self.view!,
			"lblEmptyScreen": lblEmptyScreen!
		]

		var allConstraints: [NSLayoutConstraint] = []

		// collection horizontal axis constraints
		let collectionHorizontalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "H:|[collectionView]|",
			metrics: nil, views: views)
		allConstraints += collectionHorizontalConstraints

		// collection vertical axis constraints
		let collectionVerticalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "V:|[collectionView]|",
			metrics: nil,
			views: views)
		allConstraints += collectionVerticalConstraints

		// make loader vertically center so that it appears at the centre
		let loaderVerticalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "V:[superview]-(<=1)-[loaderView(100)]",
			options: .alignAllCenterX,
			metrics: nil,
			views: views)
		allConstraints += loaderVerticalConstraints

		// make loader horizontally center so that it appears at the centre
		let loaderHorizontalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "H:[superview]-(<=1)-[loaderView(100)]",
			options: .alignAllCenterY,
			metrics: nil,
			views: views)
		allConstraints += loaderHorizontalConstraints

		// make empty text vertically center so that it appears at the centre
		let emptyTextVerticalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "V:[superview]-(<=1)-[lblEmptyScreen(250)]",
			options: .alignAllCenterX,
			metrics: nil,
			views: views)
		allConstraints += emptyTextVerticalConstraints

		// make empty text horizontally center so that it appears at the centre
		let emptyTextHorizontalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "H:[superview]-(<=1)-[lblEmptyScreen]",
			options: .alignAllCenterY,
			metrics: nil,
			views: views)
		allConstraints += emptyTextHorizontalConstraints

		NSLayoutConstraint.activate(allConstraints)
	}
}

// MARK: - VIEW MODEL BINDINGS
extension ImageListViewController {

	/// Bind view with observables from view model
	fileprivate func bindView () {
		// bind navigation title
		bindScreenTitle()

		// bind collection view
		bindCollectionView()

		// bind loader
		bindLoader()

		// bind visibility of empty text
		bindEmptyText()
	}

	/// Observable binding to collection to react on specific events
	fileprivate func bindCollectionView() {
		// observable binding to load
		// facts data into collection view
		viewModel?.imagesObservable
			.drive(
				(collectionView?.rx.items(
					cellIdentifier: ImageCollectionViewCell.reuseIdentifier,
					cellType: UICollectionViewCell.self
					))!) { [weak self]  _, data, cell in

						guard let cellTemp = cell as? ImageCollectionViewCell
							else { return }
						self?.updateCells(cell: cellTemp, data: data)

		}.disposed(by: disposeBag)

		// dispose image loading observables when cell is
		// not displaying in the cell.
		// some memory management stuffs
		collectionView?.rx.didEndDisplayingCell
			.asObservable().subscribe(onNext: { (row) in
				guard let cellTemp = row.cell as? ImageCollectionViewCell else {
					return
				}

				if let obj = cellTemp.downloadObservable {
					obj.dispose()
				}
			}).disposed(by: disposeBag)
	}

	/// observable binding for screen title
	fileprivate func bindScreenTitle() {
		viewModel?.titleObservable
			.drive(self.rx.title)
			.disposed(by: self.disposeBag)
	}

	/// observable binding to control loader animation
	fileprivate func bindLoader() {
		viewModel?.loaderObservable
			.catchErrorJustReturn(false)
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

	/// observable to control empty text visibility
	fileprivate func bindEmptyText() {
		// Display empty screen text when no collection view data is available
		viewModel?.imagesObservable.asObservable().subscribe(
			onNext: { [weak self] data in
				if data.count > 0 {
					// hide empty text when items are loaded
					self?.lblEmptyScreen?.isHidden = true
				} else {
					// show empty text when no items are there
					self?.lblEmptyScreen?.isHidden = false
				}
			},
			onError: { [weak self] _ in
				// show empty text when there is any error
				// while retreiving facts item
				self?.lblEmptyScreen?.isHidden = false
		}).disposed(by: disposeBag)
	}
}

// MARK: - MISC
extension ImageListViewController {

	/// action method , calls up when user pull to refresh
	/// screen data
	@objc func refresh () {

		// reload Screen data
		if let viewModel = viewModel {
			viewModel.loadData(forcedReload: true)
		}

		// hide pull to refresh
		self.perform(#selector(hidePullToRefresh),
					 with: refreshCollection,
					 afterDelay: 2.0)
	}

	/// action method calls up to hide pull to refresh
	@objc func hidePullToRefresh () {
		refreshCollection?.endRefreshing()
	}

	/// Updates view components of dequeued cell in collection using data
	/// - Parameters:
	///   - cell: cell of which view components needs to be updated
	///   - data: data to update in cell
	fileprivate func updateCells(cell: ImageCollectionViewCell, data: ImageViewData) {
		cell.lblTitle?.text = data.imgTitle // set fact title
		cell.lblDesc?.text = data.imgDesc // set fact description
		cell.imgView?.image = UIImage(named: PLACEHOLDER_IMAGE)

		// initiates image downloading to render downloading
		cell.downloadObservable = data.loadImage()
			.catchErrorJustReturn(UIImage(named: PLACEHOLDER_IMAGE)!)
			.bind(to:
				(cell.imgView?.rx.image)!)

		// adds cell image observable to dispose bag
		cell.downloadObservable?.disposed(by: disposeBag)
	}
}
