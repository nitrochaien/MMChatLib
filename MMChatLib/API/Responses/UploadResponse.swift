//
//  UploadResponse.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 23/09/2021.
//

import Foundation

// MARK: - UploadImageResponse
struct UploadImageResponse: Decodable {
    let fileInfos: [FileInfo]?
    let clientIDS: [String]?

    enum CodingKeys: String, CodingKey {
        case fileInfos = "file_infos"
        case clientIDS = "client_ids"
    }
}

// MARK: - FileInfo
struct FileInfo: Decodable {
    let id, userID, postID: String?
    let createAt, updateAt, deleteAt: Int?
    let name, fileInfoExtension: String?
    let size: Int?
    let mimeType: String?
    let width, height: Int?
    let hasPreviewImage: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case postID = "post_id"
        case createAt = "create_at"
        case updateAt = "update_at"
        case deleteAt = "delete_at"
        case name
        case fileInfoExtension = "extension"
        case size
        case mimeType = "mime_type"
        case width, height
        case hasPreviewImage = "has_preview_image"
    }
}
