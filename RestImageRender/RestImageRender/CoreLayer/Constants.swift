//
//  Constants.swift
//  OverdraftLimit
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import UIKit


/// Custom App colors, Entire screen colors can be change from here
struct RIRColors {
    static let primary: UIColor = #colorLiteral(red: 0.2405773699, green: 0.7062084079, blue: 1, alpha: 0.8703713613)
    static let secondary: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let tertiary: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let background: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let danger: UIColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)

    static let primaryText: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let secondaryText: UIColor = #colorLiteral(red: 0.2032293081, green: 0.2207838595, blue: 0.2443138957, alpha: 1)
}

/// Remote url to fetch fact json data
let CONTENT_URL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

/// Placeholder image for each empty image collection cell
let PLACEHOLDER_IMAGE = "placeholder"
