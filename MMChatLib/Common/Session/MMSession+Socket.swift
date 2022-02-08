//
//  MMSession+Socket.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 22/09/2021.
//

import Foundation

extension MMSession {
    func observeEvents() {
        socket.onEvent = { response in
            switch response {
                case .success(let socketEvent):
                    self.delegate?.mmSession(self, onEvent: socketEvent)
                case .failure(let error):
                    self.delegate?.mmSession(self, didOccurError: error)
            }
        }
    }
    
    func pause() {
        print("Suspend socket...")
        socket.suspendConnection()
    }

    func resume() {
        if channelId.isEmpty { return }

        do {
            try socket.resumeConnection()
        } catch {
            delegate?.mmSession(self, didOccurError: MMError.cannotResumeSocket)
        }
    }

    func connectSocket() {
        do {
            try socket.openConnection()
        } catch MMError.invalidURL {
            self.delegate?.mmSession(self, didOccurError: MMError.invalidURL)
        } catch {
            self.delegate?.mmSession(self, didOccurError: MMError.undefined)
        }
    }
}
