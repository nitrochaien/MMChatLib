//
//  MMAPI+Channels.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 22/09/2021.
//

import Foundation

public typealias ChannelId = String

extension MMAPI {
    func createChannel(between userIds: [String],
                       completion: @escaping (Result<ChannelResponse, Error>) -> Void) {
        if userIds.isEmpty {
            completion(.failure(MMError.emptyUserIds))
            return
        }

        let endPoint = apiPath + "/channels/direct"
        print(endPoint)
        guard let url = URL(string: endPoint) else {
            assertionFailure("Cannot create direct channel url.")
            return
        }
        request(type: ChannelResponse.self, method: .post, url: url, params: userIds) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func getMessages(in channelId: ChannelId, page: Int = 0, perPage: Int = 10, completion: @escaping (Result<MessagesResponse, Error>) -> Void) {
        if channelId.isEmpty {
            completion(.failure(MMError.invalidChannelId))
            return
        }
        let path = apiPath + "/channels/" + channelId + "/posts" +
        "?page=\(page)&per_page=\(perPage)"
        let endPoint = path
        print(endPoint)
        guard let url = URL(string: endPoint) else {
            assertionFailure("Cannot create get message url.")
            return
        }
        request(type: MessagesResponse.self, method: .get, url: url) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
