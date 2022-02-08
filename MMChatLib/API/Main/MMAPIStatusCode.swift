//
//  MMAPIStatusCode.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 23/09/2021.
//

import Foundation

enum MMAPIStatusCode: Int {
    case ok = 200
    case created = 201
    case invalidParams = 400
    case noAccessToken = 401
    case noPermission = 403
    case notFound = 404
    case contentTooLarge = 413
    case serverError = 500
    case featureDisabled = 501

    var toError: MMError {
        switch self {
            case .invalidParams:
                return .invalidParams
            case .noAccessToken:
                return .noAccessToken
            case .noPermission:
                return .noPermission
            case .notFound:
                return .notFound
            case .contentTooLarge:
                return .contentTooLarge
            case .featureDisabled:
                return .featureDisabled
            default:
                return .undefined
        }
    }
}
