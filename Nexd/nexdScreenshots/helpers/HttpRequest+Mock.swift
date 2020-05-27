//
//  HttpRequest+Mock.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Swifter

extension HttpRequest: CustomStringConvertible {
    public var description: String {
        return "HttpRequest: \(method) - \(path)"
    }

    func queryParam(_ key: String) -> String? {
        return queryParams.filter { $0.0 == key }.map { $0.1 }.first
    }

    var jsonBody: String? {
        return String(bytes: body, encoding: .utf8)
    }

    func parseBody<T: Decodable>() -> T? {
        let decoder = JSONDecoder()

        return try? decoder.decode(T.self, from: Data(body))
    }
}
