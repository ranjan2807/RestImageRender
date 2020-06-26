//
//  Image.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation

struct AppData: Decodable {
    var title: String?
    var items: [ImageDetail]?
}

extension AppData {
    enum CodingKeys: String, CodingKey {
        case title
        case items = "rows"
    }
}

struct ImageDetail: Decodable {
    var title: String?
    var imgDesc: String?
    var imgUrl: String?
}

extension ImageDetail {
    enum CodingKeys: String, CodingKey {
        case title
        case imgDesc = "description"
        case imgUrl = "imageHref"
    }
}
