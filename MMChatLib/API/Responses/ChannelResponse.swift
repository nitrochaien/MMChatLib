//
//  ChannelResponse.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 14/09/2021.
//

import Foundation

struct ChannelResponse: Codable {
    let id: String?
    let createAt, updateAt, deleteAt: Int?
    let teamID, type, displayName, name: String?
    let header, purpose: String?
    let lastPostAt, totalMsgCount, extraUpdateAt: Int?
    let creatorID: String?
    let shared: Bool?
    let totalMsgCountRoot: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case createAt = "create_at"
        case updateAt = "update_at"
        case deleteAt = "delete_at"
        case teamID = "team_id"
        case type
        case displayName = "display_name"
        case name, header, purpose
        case lastPostAt = "last_post_at"
        case totalMsgCount = "total_msg_count"
        case extraUpdateAt = "extra_update_at"
        case creatorID = "creator_id"
        case shared
        case totalMsgCountRoot = "total_msg_count_root"
    }
}
