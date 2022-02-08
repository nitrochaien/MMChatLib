//
//  MMSocket.swift
//  MattermostDemo
//
//  Created by Grooo Mobile Team on 13/09/2021.
//

import Foundation

public typealias MMSocketEvent = (event: MMEvent, response: EventModel)
typealias MMSocketResponse = (Result<MMSocketEvent, MMError>) -> Void

class MMSocket: NSObject {

    private(set) var socketTask: URLSessionWebSocketTask!

    private var urlSession: URLSession!
    private var timer = Timer()

    private(set) var storage: Storage!

    var onEvent: MMSocketResponse?

    public override init() {
        super.init()
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    }

    convenience init(storage: Storage) {
        self.init()
        self.storage = storage
    }

    func openConnection() throws {
        guard let url = storage.socketURL else {
            throw MMError.invalidURL
        }
        socketTask = urlSession.webSocketTask(with: url)

        print("MMSocket --- Setting up socket with url: \(url.absoluteString)...")

        socketTask.resume()
        listen()
    }

    func resumeConnection() throws {
        if socketTask != nil {
            print("Resume socket...")
            socketTask.resume()
            schedulePing()
        } else {
            try openConnection()
        }
    }

    func suspendConnection() {
        timer.invalidate()
        socketTask.suspend()
    }

    func closeConnection() {
        print("MMSocket --- Connection is closed")
        timer.invalidate()
        socketTask.cancel(with: .goingAway, reason: nil)
    }

    private func sendPing() {
        print("MMSocket --- Send ping")
        socketTask.sendPing { [unowned self] error in
            if let error = error {
                print("MMSocket --- Error:", error)
                self.closeConnection()
            }
        }
    }

    func schedulePing() {
        DispatchQueue.main.async {
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { timer in
                self.sendPing()
            })
            self.timer.fire()
        }
    }

    func listen() {
        print("Listening...")
        socketTask.receive { [unowned self] result in
            switch result {
                case .success(let response):
                    switch response {
                        case .string(let text):
                            if let data = text.data(using: .utf8) {
                                self.handleReceivedData(data)
                            } else {
                                print("MMSocket --- Cannot parse text response.")
                            }
                        case .data(let data):
                            self.handleReceivedData(data)
                        @unknown default:
                            assertionFailure("MMSocket --- Unhandled socket case.")
                    }
                    self.listen()
                case .failure(let error):
                    print("MMSocket --- Receive error:", error)
                    self.closeConnection()
            }
        }
    }

    func handleReceivedData(_ data: Data) {
        print("MMSocket --- Receive data:", data.toString)
        do {
            let response = try data.parse(GeneralEventModel.self)
            if let eventRes = response.event, !eventRes.isEmpty,
            let event = MMEvent(rawValue: eventRes) {
                switch event {
                    case .posted:
                        let messageObject = try data.parse(MessageEvent.self)
                        onEvent?(.success((.posted, messageObject)))
                    default:
                        break
                }
            } else {
                onEvent?(.failure(.noEvent))
            }
        } catch {
            onEvent?(.failure(.cannotParse))
        }
    }

    func send(_ content: String) {
        let message = URLSessionWebSocketTask.Message.string(content)
        assert(socketTask != nil, "MMSocket --- Socket task not init")
        socketTask.send(message) { error in
            if let error = error {
                print("MMSocket --- Fail to send. Error:", error)
                return
            }
            print("MMSocket --- Sent:", content)
        }
    }

    func send(_ content: Data) {
        let message = URLSessionWebSocketTask.Message.data(content)
        assert(socketTask != nil, "MMSocket --- Socket task not init")
        socketTask.send(message) { error in
            if let error = error {
                print("MMSocket --- Fail to send. Error:", error)
                return
            }
            print("MMSocket --- Sent:", content.toString)
        }
    }

    func authenticate() {
        let json: [String: Any] = [
            "seq": 1,
            "action": "authentication_challenge",
            "data": [
                "token": storage.mmToken
            ]
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            send(jsonData)
        } catch {
            print("Cannot parse json data")
        }
    }
}

extension MMSocket: URLSessionWebSocketDelegate {
    /// connection disconnected
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        print("MMSocket --- Socket closed with code:", closeCode.rawValue)
    }

    // connection established
    func urlSession(_ session: URLSession,
      webSocketTask: URLSessionWebSocketTask,
      didOpenWithProtocol protocol: String?) {
        print("MMSocket --- Socket started!")

        authenticate()
        schedulePing()
    }
}
