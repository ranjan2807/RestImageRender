//
//  ImageCollectionViewCell.swift
//  RestImageRender
//
//  Created by Newpage-iOS on 26/06/20.
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "Cell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        addLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    lazy var lblTitle: UILabel? = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = RIRColors.primaryText
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    } ()

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

    lazy var imgView: UIImageView? = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "placeholder")
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false

        return img
    } ()
}

extension ImageCollectionViewCell {
    func addViews() {
        self.contentView.addSubview(self.cardView!)
        cardView!.addSubview(self.lblTitle!)
        cardView!.addSubview(self.lblDesc!)
        cardView!.addSubview(self.imgView!)

        cardView?.backgroundColor = RIRColors.background
    }

    func addLayoutConstraints() {

        let views: [String: Any] = [
            "cardView": cardView!,
            "lblTitle": lblTitle!,
            "lblDesc": lblDesc!,
            "imgView": imgView!
        ]

        var allConstraints: [NSLayoutConstraint] = []

        let cardHorizontalConstraintlet = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[cardView]|",
        metrics: nil,
        views: views)
        allConstraints += cardHorizontalConstraintlet

        let cardVerticalConstraintlet = NSLayoutConstraint.constraints(
        withVisualFormat: "V:|[cardView]|",
        metrics: nil,
        views: views)
        allConstraints += cardVerticalConstraintlet

        // HORIZONTAL CONSTRAINTS

        let titleHorizontalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-[lblTitle]-|",
        metrics: nil,
        views: views)
        allConstraints += titleHorizontalConstraints

        let descHorizontalConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-[lblDesc]-|",
        metrics: nil,
        views: views)
        allConstraints += descHorizontalConstraints

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
