//
//  ImageDetailViewController.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import UIKit

/// protocol for image detail view controller
protocol ImageDetailViewControllerProtocol {}

class ImageDetailViewController: UIViewController, ImageDetailViewControllerProtocol {

	/// view model
	private var viewModel: ImageDetailViewModelProtocol?

	init(viewModel: ImageDetailViewModelProtocol) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Calls up just after view controller is alloc
	/// ideal time to add UI subviews and UI configurations
	override func loadView() {
		super.loadView()

		// change background color of screen with
		// app scecific background color
		self.view.backgroundColor = RIRColors.background

		// add all screen views
		addSubviews()
	}

	/// Calls up when view controller view loads up
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

		// bind collection view with the
		// image list data of viewModel
		bindView ()

		// update constraints of
		// all subviews of screen
		addLayoutConstraint()
		
    }
}

// MARK: - UI RENDER
extension ImageDetailViewController {

	/// main method to all subviews of screen
	fileprivate func addSubviews() {

	}
}

// MARK: - CONSTRAINTS
extension ImageDetailViewController {

	// adds contains to different views of screen
	fileprivate func addLayoutConstraint() {
		
	}
}

// MARK: - VIEW MODEL BINDINGS
extension ImageDetailViewController {

	/// Bind view with observables from view model
	fileprivate func bindView () {

	}
}

// MARK: - MISC
extension ImageDetailViewController {
	
}
