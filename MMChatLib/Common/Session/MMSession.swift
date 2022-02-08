//
//  MMManager.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 15/09/2021.
//

import UIKit
import Combine

public protocol MMSessionDelegate: NSObjectProtocol {
    func mmSession(_ session: MMSession, didOccurError error: Error)
    func mmSession(_ session: MMSession, didCreateChannel id: String)
    func mmSession(_ session: MMSession, onEvent event: MMSocketEvent)
}

public class MMSession: NSObject {
    private(set) var api: MMAPI!
    private(set) var socket: MMSocket!
    
    /// Do not use this value
    var subscriptionBag: Set<AnyCancellable> = []
    
    private(set) var channelId = ""
    private(set) var channelName = ""
    
    public weak var delegate: MMSessionDelegate?
    
    var onEvent: MMSocketResponse?
    
    var isConnectedToNetwork: Bool {
        MMReachability.isConnectedToNetwork
    }
    
    deinit {
        print("Deinit MMSession")
        NotificationCenter.default.removeObserver(self)
    }
    
    public init(token: String, userId: String, domain: String) {
        super.init()
        
        assert(!token.isEmpty, "Token must not empty.")
        assert(!userId.isEmpty, "User id must not empty.")
        assert(domain.isValidPath, "Domain is not valid. Example: your-domain.com.vn")
        
        let route = Route(domain: domain)
        let storage = Storage(route, token: token, userId: userId)
        api = .init(storage: storage)
        socket = .init(storage: storage)
        
        observeEvents()
        observeNotifications()
    }
    
    private func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleNotification(_ notification: Notification) {
        switch notification.name {
            case UIApplication.didEnterBackgroundNotification:
                pause()
            case UIApplication.willEnterForegroundNotification:
                resume()
            default:
                break
        }
    }
    
    public func start(between userIds: [String]) {
        if !isConnectedToNetwork {
            self.delegate?.mmSession(self, didOccurError: MMError.noInternet)
            return
        }
        api.createChannel(between: userIds) { result in
            switch result {
                case .success(let channel):
                    if let channelId = channel.id, !channelId.isEmpty {
                        self.channelId = channelId
                        self.delegate?.mmSession(self, didCreateChannel: channelId)
                        self.connectSocket()
                    } else {
                        self.delegate?.mmSession(self, didOccurError: MMError.invalidChannelId)
                    }
                    self.channelName = channel.displayName ?? ""
                case .failure(let error):
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }
    
    public func terminate() {
        channelId = ""
        channelName = ""
        socket.closeConnection()
    }
    
    public func getPreviewURLString(from id: String?) -> String {
        if let id = id, !id.isEmpty {
            return api.apiPath + "/files/" + id + "/preview"
        }
        return ""
    }

    public func getFullSizeURLString(from id: String?) -> String {
        if let id = id, !id.isEmpty {
            return api.apiPath + "/files/" + id
        }
        return ""
    }
}

private extension String {
    var isValidPath: Bool {
        if self.contains("http") || self.contains("wss") {
            return false
        }
        if String(self.suffix(1)) == "/" {
            return false
        }
        return self.isValidURL
    }
    
    var isValidURL: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                return match.range.length == self.utf16.count
            }
            return false
        } catch {
            return false
        }
    }
}
