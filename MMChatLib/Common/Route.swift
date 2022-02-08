//
//  Defines.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 14/09/2021.
//

import Foundation

struct Route {
    private(set) var socketPath: String
    private(set) var apiPath: String

    init(domain: String) {
        socketPath = "wss://" + domain + "/api/v4/websocket"
        apiPath = "https://" + domain + "/api/v4"
    }
}
