//
//  Common.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 15/09/2021.
//

import Foundation

struct Storage {
    private(set) var mmToken: String
    private(set) var mmUserId: String
    private(set) var route: Route

    init(_ route: Route, token: String, userId: String) {
        self.route = route
        self.mmToken = token
        self.mmUserId = userId
    }

    var socketURL: URL? {
        return URL(string: route.socketPath)
    }
}
