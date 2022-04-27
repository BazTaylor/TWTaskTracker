//
//  APIError.swift
//  TWTaskTracker
//
//  Created by Alan Taylor on 26/04/2022.
//

import Foundation

/**
 Custom API Error class for better error handing from API requests..
 */
enum APIError: Error, Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        return true
    }
    
    case noResponse
    case noData
    case api(message: String?, responseCode: Int)
    case decodeError(error: Error)
    case error(error: Error)
    case unknown
}

/**
 Extension to APIError which provides Localized String descriptions for the error.
 Can be used for user facing strings that describe a problem.
 https://www.advancedswift.com/custom-errors-in-swift/
 */
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noResponse:
            return NSLocalizedString("No Response Object", comment: "No Response Object")
        case .noData:
            return NSLocalizedString("No Data Object", comment: "No Data Object")
        case .api(message: let message, responseCode: let responseCode):
            return "httpStatusCode=\(responseCode) message=\(message ?? "No message provided from API.")"
        case .decodeError(error: let error):
            return error.localizedDescription
        case .error(error: let error):
            return error.localizedDescription
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "Unknown Error")
        }
    }
}

// MARK: - API Error Message

/**
 Error response from API contains a message string
 */
struct ErrorMessage: Codable {
    let message: String?
}
