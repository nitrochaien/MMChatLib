//
//  MMError.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 15/09/2021.
//

import Foundation

enum MMError: CustomNSError, LocalizedError {
    // App errors
    case invalidChannelId
    case emptyUserIds
    case undefined
    case cannotParse

    // API errors
    case noInternet
    case invalidParams
    case noAccessToken
    case noPermission
    case notFound
    case serverError
    case contentTooLarge
    case featureDisabled

    // Socket errors
    case invalidURL
    case noEvent
    case cannotResumeSocket

    var errorDescription: String? {
        switch self {
            case .invalidChannelId:
                return "Invalid channel id"
            case .undefined:
                return "Undefined error"
            case .cannotParse:
                return "Cannot parse data"
            case .invalidParams:
                return "Invalid params"
            case .noAccessToken:
                return "Access token missing"
            case .noPermission:
                return "You don't have permission to request this API"
            case .notFound:
                return "API not found"
            case .serverError:
                return "Server error"
            case .invalidURL:
                return "Invalid URL"
            case .noEvent:
                return "Undefined event"
            case .cannotResumeSocket:
                return "Cannot resume socket"
            case .featureDisabled:
                return "Feature is disabled"
            case .contentTooLarge:
                return "Content too large"
            case .emptyUserIds:
                return "User ids must not be empty"
            case .noInternet:
                return "No internet connection"
        }
    }

    /* TODO: Implement CustomNSError https://stackoverflow.com/questions/39176196/how-to-provide-a-localized-description-with-an-error-type-in-swift
     */
}
