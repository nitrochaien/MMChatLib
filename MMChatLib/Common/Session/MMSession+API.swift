//
//  MMSession+API.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 22/09/2021.
//

import Foundation

extension MMSession {
    public func sendTypingNoti() {
        if !isConnectedToNetwork {
            return
        }
        api.sendTyping(channelId: channelId) { result in
            switch result {
                case .success:
                    print("Sent typing event")
                case .failure(let error):
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }

    public func send(_ message: String) {
        if !isConnectedToNetwork {
            self.delegate?.mmSession(self, didOccurError: MMError.noInternet)
            return
        }
        send(message, imagesData: [])
    }


    /// Send message with image and message
    /// - Parameters:
    ///   - message: Text content input by user
    ///   - imagesData: List of image data by user
    ///   - progress: Progress of uploading images with index of each image. Format: index, progress
    ///   - completion: Callback when all is finished
    public func send(_ message: String,
                     imagesData: [Data],
                     progress: ((Int, Double) -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        if !isConnectedToNetwork {
            self.delegate?.mmSession(self, didOccurError: MMError.noInternet)
            return
        }

        if imagesData.isEmpty {
            self.sendFile(message: message, fileIds: []) {
                completion?()
            }
        } else {
            let sendFileGroup = DispatchGroup()

            var fileIds = [String]()
            for (index, data) in imagesData.enumerated() {
                sendFileGroup.enter()
                self.uploadImage(with: data) { percentage in
                    progress?(index, percentage * 100)
                } completion: { response in
                    if let fileId = response.fileInfos?.first?.id, !fileId.isEmpty {
                        fileIds.append(fileId)
                    }
                    progress?(index, 100)
                    sendFileGroup.leave()
                }
            }

            sendFileGroup.notify(queue: .global(qos: .userInitiated)) {
                let sendMessageGroup = DispatchGroup()
                let chunks = fileIds.chunked(into: 5)
                for chunk in chunks {
                    sendMessageGroup.enter()
                    self.sendFile(message: message, fileIds: chunk) {
                        sendMessageGroup.leave()
                    }
                }
                sendMessageGroup.notify(queue: .main) {
                    completion?()
                }
            }
        }
    }

    private func sendFile(message: String, fileIds: [String], completion: (() -> Void)? = nil) {
        api.createPost(channelId: channelId, message: message, fileIds: fileIds) { result in
            switch result {
                case .success:
                    completion?()
                case .failure(let error):
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }

    private func uploadImage(with imageData: Data,
                             progress: ((Double) -> Void)? = nil,
                             completion: ((UploadImageResponse) -> Void)? = nil) {
        api.uploader
            .upload(fileData: imageData, channelId: channelId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [unowned self] completion in
                if case let .failure(error) = completion {
                    self.delegate?.mmSession(self, didOccurError: error)
                }
            }, receiveValue: { uploadResponse in
                switch uploadResponse {
                    case let .progress(percentage):
                        progress?(percentage)
                    case let .response(responseData):
                        completion?(responseData)
                }
            })
            .store(in: &subscriptionBag)
    }

    public func getMessages(page: Int, perPage: Int, completion: @escaping ([Post]?) -> Void) {
        if !isConnectedToNetwork {
            self.delegate?.mmSession(self, didOccurError: MMError.noInternet)
            return
        }
        api.getMessages(in: channelId, page: page, perPage: perPage) { result in
            switch result {
                case .success(let response):
                    let posts = response.posts?.compactMap { $0.1 } ?? []
                    completion(posts)
                case .failure(let error):
                    completion(nil)
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }

    public func getUnreadCount(of userId: String, completion: @escaping (Int?) -> Void) {
        if !isConnectedToNetwork {
            self.delegate?.mmSession(self, didOccurError: MMError.noInternet)
            return
        }
        api.getUnreadCount(channelId: channelId, userId: userId) { result in
            switch result {
                case .success(let response):
                    let count = response.msgCount ?? 0
                    completion(count)
                case .failure(let error):
                    completion(nil)
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }

    public func editMessage(_ id: PostId, message: String, completion: @escaping (Post?) -> Void) {
        if !isConnectedToNetwork {
            self.delegate?.mmSession(self, didOccurError: MMError.noInternet)
            return
        }
        api.updatePost(id, message: message) { result in
            switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    completion(nil)
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }

    public func deleteMessage(_ id: PostId, message: String, completion: @escaping () -> Void) {
        if !isConnectedToNetwork {
            self.delegate?.mmSession(self, didOccurError: MMError.noInternet)
            return
        }
        api.deletePost(id) { result in
            switch result {
                case .success:
                    completion()
                case .failure(let error):
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }

    public func getReactionList(_ postId: PostId, completion: @escaping (ReactionListResponse?) -> Void) {
        if !isConnectedToNetwork {
            self.delegate?.mmSession(self, didOccurError: MMError.noInternet)
            return
        }
        api.getReactionList(of: postId) { result in
            switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    completion(nil)
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }

    public func removeReaction(_ postId: PostId, emojiName: String, completion: @escaping () -> Void) {
        if !isConnectedToNetwork {
            self.delegate?.mmSession(self, didOccurError: MMError.noInternet)
            return
        }
        let userId = api.storage.mmUserId
        api.removeReaction(by: userId, postId: postId, emojiName: emojiName) { result in
            switch result {
                case .success:
                    completion()
                case .failure(let error):
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
