//
//  ImageCollectionViewCell.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import UIKit
import RxSwift

/// Cell class for collection view
final class ImageCollectionViewCell: UICollectionViewCell {

	/// Reuse identifier to dequeue collection cell
    static let reuseIdentifier = "Cell"

	/// Observable to control downloading and rendering of cell image
	var downloadObservable: Disposable?

	/// Designated initializer for cell class
	///  Add all  subview layout and configuration here
	/// - Parameter frame: Frame of cell
    override init(frame: CGRect) {
        super.init(frame: frame)

		// add all sub view of cell
        addViews()

		// add contraints to cell sub views
        addLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	/// View to add card view effect to the cell
    lazy var cardView: UIView? = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        //view.layer.cornerRadius = 10.0
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false

        return view
    } ()

	/// title label of cell
    lazy var lblTitle: UILabel? = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = RIRColors.primaryText
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    } ()

	/// Descrition label of cell
    lazy var lblDesc: UILabel? = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = RIRColors.secondaryText
        label.font = UIFont.systemFont(ofSize: 9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true

        return label
    } ()

	/// Image view of cell
    lazy var imgView: UIImageView? = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: PLACEHOLDER_IMAGE)
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false

        return img
    } ()
}

// MARK: - UI RENDERING
extension ImageCollectionViewCell {

	/// Adds subview to cell
    func addViews() {
		// add card view to cell
        self.contentView.addSubview(self.cardView!)

		// add imageview, title label, desc lable to card view
        cardView!.addSubview(self.lblTitle!)
        cardView!.addSubview(self.lblDesc!)
        cardView!.addSubview(self.imgView!)

		// add app background color to cell
        cardView?.backgroundColor = RIRColors.background
    }

	/// Add constraints to cell sub views
    func addLayoutConstraints() {

        let views: [String: Any] = [
            "cardView": cardView!,
            "lblTitle": lblTitle!,
            "lblDesc": lblDesc!,
            "imgView": imgView!
        ]

        var allConstraints: [NSLayoutConstraint] = []

		/// Pin card view to left and right side of cell
        let cardHorizontalConstraintlet = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[cardView]|",
        metrics: nil,
        views: views)
        allConstraints += cardHorizontalConstraintlet

		/// Pin card view to top and bottom of cell
        let cardVerticalConstraintlet = NSLayoutConstraint.constraints(
        withVisualFormat: "V:|[cardView]|",
        metrics: nil,
        views: views)
        allConstraints += cardVerticalConstraintlet

        // HORIZONTAL CONSTRAINTS

		/// Pin horizontal constraints of title label
        let titleHorizontalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-10-[lblTitle]-10-|",
        metrics: nil,
        views: views)
        allConstraints += titleHorizontalConstraints

		/// Pin Horizontal containts of desc label
        let descHorizontalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-10-[lblDesc]-10-|",
        metrics: nil,
        views: views)
        allConstraints += descHorizontalConstraints

		/// Pin Horizontal constraints of image view
        let imgHorizontalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[imgView]|",
        metrics: nil,
        views: views)
        allConstraints += imgHorizontalConstraints

        // VERTICAL CONSTRAINTS
        let verticalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "V:|[imgView]-5-[lblTitle]-0-[lblDesc]|",
        metrics: nil,
        views: views)
        allConstraints += verticalConstraints

        NSLayoutConstraint.activate(allConstraints)
    }
}
