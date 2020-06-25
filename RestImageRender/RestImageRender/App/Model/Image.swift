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

    // to handle the case
    // when feilds appeared
    // have null values
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
//        items = try (container.decodeIfPresent([ImageDetail].self, forKey: .items) ?? [])
//    }
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

    // to handle the case
    // when feilds appeared
    // have null values
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
//        imgDesc = try (container.decodeIfPresent(String.self, forKey: .imgDesc) ?? "")
//        imgUrl = try (container.decodeIfPresent(String.self, forKey: .imgUrl) ?? "")
//    }
}

extension ImageDetail {
    enum CodingKeys: String, CodingKey {
        case title
        case imgDesc = "description"
        case imgUrl = "imageHref"
    }
}
