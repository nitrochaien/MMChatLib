//
//  MessageEvent.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 18/09/2021.
//

import Foundation

// MARK: - MessageEvent
public struct MessageEvent: Decodable, EventModel {
    public var event: String?
    public let data: MessageEventData?
    public var broadcast: EventBroadcast?
    public var seq: Int?

    public var post: Post? {
        let msgData = data?.post?.data(using: .utf8)
        return try? msgData?.parse(Post.self)
    }
}

// MARK: - DataClass
public struct MessageEventData: Decodable {
    public let channelDisplayName, channelName, channelType, mentions: String?
    public let senderName: String?
    public let post: String?
    public let setOnline: Bool?
    public let teamID: String?

    enum CodingKeys: String, CodingKey {
        case channelDisplayName = "channel_display_name"
        case channelName = "channel_name"
        case channelType = "channel_type"
        case mentions, post
        case senderName = "sender_name"
        case setOnline = "set_online"
        case teamID = "team_id"
    }
}

// MARK: - Post
public struct Post: Decodable {
    public let id: String?
    public let createAt, updateAt, editAt, deleteAt: Int?
    public let isPinned: Bool?
    public let userID, channelID, rootID, parentID: String?
    public let originalID, message, type: String?
    public let props: Props?
    public let hashtags, pendingPostID: String?
    public let replyCount, lastReplyAt: Int?
    public let isFollowing: Bool?
    public let metadata: Metadata?

    enum CodingKeys: String, CodingKey {
        case id
        case createAt = "create_at"
        case updateAt = "update_at"
        case editAt = "edit_at"
        case deleteAt = "delete_at"
        case isPinned = "is_pinned"
        case userID = "user_id"
        case channelID = "channel_id"
        case rootID = "root_id"
        case parentID = "parent_id"
        case originalID = "original_id"
        case message, type, props, hashtags
        case pendingPostID = "pending_post_id"
        case replyCount = "reply_count"
        case lastReplyAt = "last_reply_at"
        case isFollowing = "is_following"
        case metadata
    }
}

// MARK: - Props
public struct Props: Codable {
}

// MARK: - Metadata
public struct Metadata: Codable {
    public let files: [MMFile]?
}

// MARK: - File
public struct MMFile: Codable {
    public let id, userID, postID, channelID: String?
    public let createAt, updateAt, deleteAt: Int?
    public let name, fileExtension: String?
    public let size: Int?
    public let mimeType: String?
    public let width, height: Int?
    public let hasPreviewImage: Bool?
    public let remoteID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case postID = "post_id"
        case channelID = "channel_id"
        case createAt = "create_at"
        case updateAt = "update_at"
        case deleteAt = "delete_at"
        case name
        case fileExtension = "extension"
        case size
        case mimeType = "mime_type"
        case width, height
        case hasPreviewImage = "has_preview_image"
        case remoteID = "remote_id"
    }
}
