//
//  ChannelViewEvent.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 18/09/2021.
//

import Foundation

// MARK: - ChannelViewEvent
public struct ChannelViewEvent: Decodable, EventModel {
    public var event: String?
    let data: ChannelViewEventData?
    public var broadcast: EventBroadcast?
    public var seq: Int?
}

// MARK: - DataClass
struct ChannelViewEventData: Decodable {
    let channelID: String?

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
    }
}
