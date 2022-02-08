//
//  HelloEventModel.swift
//  MattermostDemo
//
//  Created by Grooo Mobile Team on 13/09/2021.
//

import Foundation

public protocol EventModel {
    var event: String? { get set }
    var broadcast: EventBroadcast? { get set }
    var seq: Int? { get set }
}

struct GeneralEventModel: Decodable, EventModel {
    public var event: String?
    public var broadcast: EventBroadcast?
    public var seq: Int?
}

public struct EventBroadcast: Decodable {
    let userId: String?
    let channelId: String?
    let teamId: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case channelId = "channel_id"
        case teamId = "team_id"
    }
}
