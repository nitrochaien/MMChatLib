//
//  MMAPI+User.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 22/09/2021.
//

import Foundation

extension MMAPI {
    func sendTyping(channelId: ChannelId, completion: @escaping (Result<StatusResponse, Error>) -> Void) {
        if channelId.isEmpty {
            completion(.failure(MMError.invalidChannelId))
            return
        }

        let userId = storage.mmUserId
        let endPoint = apiPath + "/users/" + userId + "/typing"
        print(endPoint)

        guard let url = URL(string: endPoint) else {
            assertionFailure("Cannot create typing url.")
            return
        }
        let params = [
            "channel_id": channelId
        ]
        request(type: StatusResponse.self, method: .post, url: url, params: params) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func getUnreadCount(channelId: ChannelId, userId: String, completion: @escaping (Result<UnreadCountResponse, Error>) -> Void) {
        if channelId.isEmpty {
            completion(.failure(MMError.invalidChannelId))
            return
        }
        
        let endPoint = apiPath + "/users/" + userId + "/channels/" + channelId + "/unread"
        print(endPoint)

        guard let url = URL(string: endPoint) else {
            assertionFailure("Cannot create get unread count url.")
            return
        }
        request(type: UnreadCountResponse.self, method: .get, url: url) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
