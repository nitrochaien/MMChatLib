//
//  ReactionListResponse.swift
//  MMChatLib
//
//  Created by Grooo Mobile Team on 13/12/2021.
//

import Foundation

public struct ReactionListItem: Codable {
    let userId, postId, emojiName: String?
    let createAt: Int?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case postId = "post_id"
        case emojiName = "emoji_name"
        case createAt = "create_at"
    }
}

public typealias ReactionListResponse = [ReactionListItem]
