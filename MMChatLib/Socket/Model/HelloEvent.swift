//
//  HelloEvent.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 18/09/2021.
//

import Foundation

public struct HelloEvent: Decodable, EventModel {
    public var event: String?
    public var broadcast: EventBroadcast?
    public var seq: Int?
    let data: HelloEventData?
}

struct HelloEventData: Decodable {
    let connectionId: String?
    let serverVersion: String?

    enum CodingKeys: String, CodingKey {
        case connectionId = "connection_id"
        case serverVersion = "server_version"
    }
}
