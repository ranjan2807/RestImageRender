//
//  Localization.swift
//  OverdraftLimit
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation

/// String class extention to conveniently localize app strings
extension String {
	
	/// Localized value of current string from localization files
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
