//
//  RIRError.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation

/// Enumeration for App error codes
enum RIRErrorCode {
	case emptyField
	case dataNotFound
	case noNetwork
	case parseError
	case customError
	case unknown
}

/// App Custom error class
struct RIRError: LocalizedError {

	/// message of error
	private var message: String

	/// code specific for an error
	private var code: RIRErrorCode

	/// user info dictionary to store error information in key-value format
	private var userInfo: Dictionary<String, String>?

	/// factory instance for generating custom error class
	static let factory = RIRErrorFactory.instance

	// designated initializer
	private init(message: String, code: RIRErrorCode, userInfo: Dictionary<String, String>? = nil ) {
		self.message = message
		self.code = code
		self.userInfo = userInfo
	}

	// Inner Factory class for error
	struct RIRErrorFactory {

		private init() {}

		static let instance = RIRErrorFactory()

		/// Error to throw, when a specific feild value is empty
		/// - Parameter userInfo: user info dictionary to store error information in key-value format
		func feildEmptyError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(message: "Feild value not found".localized,
							code: .emptyField,
							userInfo: userInfo)
		}

		/// Error to throw, when the concern data is nil or not found
		/// - Parameter userInfo: user info dictionary to store error information in key-value format
		func dataNotFoundError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(message: "Data not found".localized,
							code: .dataNotFound,
							userInfo: userInfo)
		}

		/// Error to throw, when json data parsing results in some error
		/// - Parameter userInfo: user info dictionary to store error information in key-value format
		func jsonParsingError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(message: "JSON parsing error".localized,
							code: .dataNotFound,
							userInfo: userInfo)
		}

		/// Error to throw when connection is made and network connectivity is not there
		/// - Parameter userInfo: user info dictionary to store error information in key-value format
		func noNetworkError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(message: "The Internet connection appears to be offline.".localized,
							code: .noNetwork,
							userInfo: userInfo)
		}

		/// Any custom error
		/// - Parameters:
		///   - domain: Error domain info
		///   - userInfo: user info dictionary to store error information in key-value format
		func customError(message: String = "Something went wrong. Please try after sometime.".localized,
						 userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(message: message,
							code: .customError,
							userInfo: userInfo)
		}

		/// Unknown error
		/// - Parameter userInfo: user info dictionary to store error information in key-value format
		func unknownError(userInfo: Dictionary<String, String>? = [:] ) -> RIRError {
			return RIRError(message: "Unknown error occurred".localized,
							code: .dataNotFound,
							userInfo: userInfo)
		}
	}
}
