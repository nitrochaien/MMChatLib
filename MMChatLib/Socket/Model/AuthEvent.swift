//
//  AuthEvent.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 18/09/2021.
//

import Foundation

public struct AuthEvent: Decodable {
    let status: String?
    let seqReply: Int?

    enum CodingKeys: String, CodingKey {
        case status
        case seqReply = "seq_reply"
    }
}
