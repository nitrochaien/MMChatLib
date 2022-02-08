//
//  MessagesResponse.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 22/09/2021.
//

import Foundation

// MARK: - MessagesResponse
struct MessagesResponse: Decodable {
    let order: [String]?
    let posts: [String: Post]?
    let nextPostID, prevPostID: String?

    enum CodingKeys: String, CodingKey {
        case order, posts
        case nextPostID = "next_post_id"
        case prevPostID = "prev_post_id"
    }
}
