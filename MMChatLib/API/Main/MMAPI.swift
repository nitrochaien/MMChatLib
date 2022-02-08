//
//  MMAPI.swift
//  MMDemo1
//
//  Created by Grooo Mobile Team on 14/09/2021.
//

import Foundation

class MMAPI: NSObject {
    private(set) var storage: Storage!
    
    private(set) lazy var uploader: MMUploader = {
        return .init(storage: storage)
    }()

    init(storage: Storage) {
        super.init()
        self.storage = storage
    }

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    var apiPath: String {
        return storage.route.apiPath
    }

    var authToken: String {
        return "Bearer " + storage.mmToken
    }

    func request<T: Decodable>(type: T.Type,
                               method: HTTPMethod,
                               url: URL,
                               params: Any? = nil,
                               completion: @escaping (Result<T, Error>) -> Void) {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.addValue(authToken, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let params = params {
                let data = try convertToData(input: params)
                request.httpBody = data
            }

            let session = URLSession.shared
            session
                .dataTask(with: request, completionHandler: { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let httpRes = response as? HTTPURLResponse {
                        let statusCode = httpRes.statusCode
                        let code = MMAPIStatusCode(rawValue: statusCode) ?? .serverError
                        switch code {
                            case .ok, .created:
                                if let object = data?.toObject(type: T.self) {
                                    completion(.success(object))
                                } else {
                                    completion(.failure(MMError.cannotParse))
                                }
                            default:
                                completion(.failure(code.toError))
                        }
                    }
                })
                .resume()
        } catch let error {
            print("Error encode params:", error.localizedDescription)
        }
    }

    private func convertToData(input: Any) throws -> Data? {
        return try JSONSerialization
            .data(withJSONObject: input, options: .prettyPrinted)
    }
}

extension Data {
    func toObject<T: Decodable>(type: T.Type) -> T? {
        try? JSONDecoder().decode(T.self, from: self)
    }
}
