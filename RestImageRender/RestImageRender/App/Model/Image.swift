//
//  Image.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation

/// Top level JSON model
struct AppData: Decodable {
    var title: String? // json title
    var items: [ImageDetail]? // json items
}

// specifies json leaf keys and map them to model properties
extension AppData {
    enum CodingKeys: String, CodingKey {
        case title
        case items = "rows"
    }
}
// Row model of JSON
struct ImageDetail: Decodable {
    var title: String? // fact title
    var imgDesc: String? // fact description
    var imgUrl: String? // fact url
}

// specifies json leaf keys and map them to model properties
extension ImageDetail {
    enum CodingKeys: String, CodingKey {
        case title
        case imgDesc = "description"
        case imgUrl = "imageHref"
    }
}
