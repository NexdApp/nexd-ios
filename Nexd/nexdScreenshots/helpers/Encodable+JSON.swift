//
//  Encodable+JSON.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation

extension Encodable {
    var jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(self)
    }

    var jsonString: String? {
        guard let data = jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }

    var byteArray: [UInt8]? {
        guard let data = jsonData else { return nil }
        return [UInt8](data)
    }
}
