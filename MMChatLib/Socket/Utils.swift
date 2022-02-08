//
//  Utils.swift
//  MattermostDemo
//
//  Created by Grooo Mobile Team on 13/09/2021.
//

import Foundation

extension Data {
    var toString: String {
        return String(data: self, encoding: .utf8) ?? ""
    }

    func parse<T: Decodable>(_ type: T.Type) throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
