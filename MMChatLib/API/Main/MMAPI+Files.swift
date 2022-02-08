//
//  MMAPI+Files.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 22/09/2021.
//

import Foundation
import Combine

enum UploadResponse {
    case progress(percentage: Double)
    case response(data: UploadImageResponse)
}

class MMUploader: MMAPI {

    typealias Progress = (id: Int, progress: Double)
    private let progress: PassthroughSubject<Progress, Never> = .init()

    private lazy var urlSession = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: .current
    )

    func upload(fileData: Data, channelId: ChannelId) -> AnyPublisher<UploadResponse, Error> {
        let subject: PassthroughSubject<UploadResponse, Error> = .init()

        if channelId.isEmpty {
            subject.send(completion: .failure(MMError.invalidChannelId))
            return subject.eraseToAnyPublisher()
        }

        let endPoint = apiPath + "/files"
        guard let url = URL(string: endPoint) else {
            subject.send(completion: .failure(MMError.invalidURL))
            return subject.eraseToAnyPublisher()
        }
        let boundary = UUID().uuidString
        let params = ["channel_id": channelId]

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")

        let httpBody = NSMutableData()
        for (key, value) in params {
            let formField = convertFormField(named: key, value: value, using: boundary)
            httpBody.appendString(formField)
        }
        let imageName = String.random(ofLength: 10)
        let fileData = convertFileData(fieldName: "files",
                                       fileName: "\(imageName).jpg",
                                       mimeType: "image/jpg",
                                       fileData: fileData,
                                       using: boundary)
        httpBody.append(fileData)
        httpBody.appendString("--\(boundary)--")

        let task = urlSession.uploadTask(with: request, from: httpBody as Data) { data, response, error in
            if let error = error {
                print("Failed:", error.localizedDescription)
                return
            }
            if let httpRes = response as? HTTPURLResponse {
                let statusCode = httpRes.statusCode
                let code = MMAPIStatusCode(rawValue: statusCode) ?? .serverError
                switch code {
                    case .ok, .created:
                        if let object = data?.toObject(type: UploadImageResponse.self) {
                            subject.send(.response(data: object))
                        } else {
                            subject.send(completion: .failure(MMError.cannotParse))
                        }
                    default:
                        subject.send(completion: .failure(code.toError))
                }
            }
        }
        task.resume()

        return progress
            .filter { $0.id == task.taskIdentifier }
            .setFailureType(to: Error.self)
            .map { .progress(percentage: $0.progress) }
            .merge(with: subject)
            .eraseToAnyPublisher()
    }

    private func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()

        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")

        return data as Data
    }
}

extension MMUploader: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        progress.send((id: task.taskIdentifier, progress: task.progress.fractionCompleted))
    }
}

private extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

private extension String {
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }

    var toData: Data? {
        return data(using: .utf8, allowLossyConversion: false)
    }
}
