//
//  MMAPI+Reactions.swift
//  MMChatLib
//
//  Created by Grooo Mobile Team on 13/12/2021.
//

import Foundation

extension MMAPI {
    func getReactionList(of postId: PostId, completion: @escaping (Result<ReactionListResponse, Error>) -> Void) {
        let endPoint = apiPath + "/posts/" + postId + "/reactions"
        print(endPoint)

        guard let url = URL(string: endPoint) else {
            assertionFailure("Cannot create reaction list url.")
            return
        }
        request(type: ReactionListResponse.self, method: .get, url: url) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func removeReaction(by userId: String, postId: PostId, emojiName: String, completion: @escaping (Result<StatusResponse, Error>) -> Void) {
        let endPoint = apiPath + "/users/" + userId + "/posts/" + postId + "/reactions" + "\(emojiName)"
        print(endPoint)
        guard let url = URL(string: endPoint) else {
            assertionFailure("Cannot create reaction list url.")
            return
        }
        request(type: StatusResponse.self, method: .delete, url: url) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
