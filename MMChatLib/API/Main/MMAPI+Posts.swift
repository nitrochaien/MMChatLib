//
//  MMAPI+Posts.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 22/09/2021.
//

import Foundation

public typealias PostId = String

extension MMAPI {
    func createPost(channelId: ChannelId, message: String, fileIds: [String], completion: @escaping (Result<Post, Error>) -> Void) {
        if channelId.isEmpty {
            completion(.failure(MMError.invalidChannelId))
            return
        }
        
        let endPoint = apiPath + "/posts"
        print(endPoint)
        guard let url = URL(string: endPoint) else {
            assertionFailure("Cannot create typing url.")
            return
        }
        var params: [String: Any] = [
            "channel_id": channelId,
            "message": message
        ]
        if !fileIds.isEmpty {
            params.updateValue(fileIds, forKey: "file_ids")
        }
        request(type: Post.self, method: .post, url: url, params: params) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func updatePost(_ id: PostId, message: String, completion: @escaping (Result<Post, Error>) -> Void) {
        let endPoint = apiPath + "/posts/" + "\(id)"
        print(endPoint)
        guard let url = URL(string: endPoint) else {
            assertionFailure("Cannot create update post url.")
            return
        }
        let params: [String: Any] = [
            "id": id,
            "isPinned": false,
            "message": message,
            "has_reactions": true
        ]
        request(type: Post.self, method: .put, url: url, params: params) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func deletePost(_ id: PostId, completion: @escaping (Result<StatusResponse, Error>) -> Void) {
        let endPoint = apiPath + "/posts/" + "\(id)"
        print(endPoint)
        guard let url = URL(string: endPoint) else {
            assertionFailure("Cannot create delete post url")
            return
        }
        request(type: StatusResponse.self, method: .delete, url: url) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
