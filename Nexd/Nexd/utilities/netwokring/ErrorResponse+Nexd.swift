//
//  NexdClient+Nexd.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient

extension ErrorResponse {
    var apiError: Error? {
        guard case let ErrorResponse.error(_, _, error) = self else { return nil }

        return error
    }

    var statusCode: Int? {
        guard case let ErrorResponse.error(statusCode, _, _) = self else { return nil }

        return statusCode
    }

    var httpStatusCode: HTTPStatusCode? {
        guard let statusCode = statusCode else { return nil }

        return HTTPStatusCode(rawValue: statusCode)
    }
}
