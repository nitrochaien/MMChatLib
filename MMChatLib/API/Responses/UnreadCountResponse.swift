//
//  UnreadCountResponse.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 22/09/2021.
//

import Foundation

// MARK: - UnreadCountResponse
struct UnreadCountResponse: Decodable {
    let teamID, channelID: String?
    let msgCount, mentionCount, mentionCountRoot, msgCountRoot: Int?

    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case channelID = "channel_id"
        case msgCount = "msg_count"
        case mentionCount = "mention_count"
        case mentionCountRoot = "mention_count_root"
        case msgCountRoot = "msg_count_root"
    }
}
