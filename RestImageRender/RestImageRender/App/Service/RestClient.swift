//
//  RestClient.swift
//  RestImageRender
//
//  Created by Newpage-iOS on 25/06/20.
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import Alamofire

protocol RestClientProtocol {
    func loadData(completion: @escaping (AppData) -> Void)
}

struct RestClient: RestClientProtocol {

    func loadData( completion: @escaping (AppData) -> Void) {

        AF.request(
            "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        ).validate()
            .responseJSON { response in
                let stringValue = String(decoding: response.data!, as: UTF8.self)
                let dataTemp = Data(stringValue.utf8)

                do {
                    let appData = try JSONDecoder().decode(AppData.self, from: dataTemp)
                    completion(appData)
                } catch {
                    print(error)
                }
        }
    }
}
