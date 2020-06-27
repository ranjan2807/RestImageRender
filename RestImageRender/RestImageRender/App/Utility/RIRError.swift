//
//  RIRError.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation

enum RIRErrorCode {
	case emptyField
	case dataNotFound
	case noNetwork
	case parseError
	case customError
	case unknown
}

struct RIRError: LocalizedError {
	private var domain: String
	private var code: RIRErrorCode
	private var userInfo: Dictionary<String, String>?

	static let factory = RIRErrorFactory.instance

	// designated initializer
	private init(domain: String, code: RIRErrorCode, userInfo: Dictionary<String, String>? = nil ) {
		self.domain = domain
		self.code = code
		self.userInfo = userInfo
	}

	// Factory class for error
	struct RIRErrorFactory {

		private init() {}

		static let instance = RIRErrorFactory()

		func feildEmptyError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(domain: "Feild value not found".localized,
							code: .emptyField,
							userInfo: userInfo)
		}

		func dataNotFoundError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(domain: "Data not found".localized,
							code: .dataNotFound,
							userInfo: userInfo)
		}

		func jsonParsingError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(domain: "JSON parsing error".localized,
							code: .dataNotFound,
							userInfo: userInfo)
		}

		func noNetworkError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(domain: "The Internet connection appears to be offline.".localized,
							code: .noNetwork,
							userInfo: userInfo)
		}

		func customError(domain: String = "Something went wrong. Please try after sometime.".localized,
						 userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(domain: domain,
							code: .customError,
							userInfo: userInfo)
		}

		func unknownError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(domain: "Unknown error occurred".localized,
							code: .dataNotFound,
							userInfo: userInfo)
		}
	}
}
