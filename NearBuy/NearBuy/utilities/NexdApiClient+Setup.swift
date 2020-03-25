//
//  OpenAPI+NearBuy.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 25.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient

extension NexdClientAPI {
    static func setup(authorizationToken: String?) {
        #if DEBUG
            NexdClientAPI.requestBuilderFactory = DebuggableURLSessionRequestBuilderFactory()
        #endif

        NexdClientAPI.basePath = AppConfiguration.baseUrl

        if let token = authorizationToken {
            NexdClientAPI.customHeaders = ["Authorization": "Bearer \(token)"]
        }
    }

    static func logRequest<T>(request: RequestBuilder<T>) {
        log.debug("Start request: \(request)")

        if let parametersDescription = request.parametersDescription {
            log.debug("Parameters: \(parametersDescription)")
        }
    }

    static func logResult<T>(result: Result<Response<T>, Error>) {
        log.debug("Request complete: \(self)")
        switch result {
        case let .success(response):
            log.debug("Success:")
            log.debug("- Status: \(response.statusCode)")
            log.debug("- Header: \(response.header)")
            if let body = response.body {
                log.debug("- Body \(body)")
            }
        case let .failure(error):
            log.error("Error:")

            if case let ErrorResponse.error(statusCode, data, error) = error {
                log.error("Status: \(statusCode), error: \(error), data: \(data?.asString() ?? "-")")
                return
            }

            log.error("\(error.localizedDescription) (\(error))")
        }
    }
}

private class DebuggableURLSessionRequestBuilderFactory: RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        return DebuggableURLSessionRequestBuilder<T>.self
    }

    func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type {
        return DebuggableURLSessionDecodableRequestBuilder<T>.self
    }
}

private class DebuggableURLSessionRequestBuilder<T>: URLSessionRequestBuilder<T> {
    override func execute(_ apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, Error>) -> Void) {
        NexdClientAPI.logRequest(request: self)

        super.execute(apiResponseQueue) { result in
            NexdClientAPI.logResult(result: result)
            completion(result)
        }
    }
}

private class DebuggableURLSessionDecodableRequestBuilder<T: Decodable>: URLSessionDecodableRequestBuilder<T> {
    override func execute(_ apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, Error>) -> Void) {
        NexdClientAPI.logRequest(request: self)

        super.execute(apiResponseQueue) { result in
            NexdClientAPI.logResult(result: result)
            completion(result)
        }
    }
}

extension RequestBuilder: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(method) - \(URLString)"
    }

    public var parametersDescription: String? {
        return parameters?.map { key, value -> String in
            switch value {
            case let v as Data:
                return "\(key): \(v.asString())"
            default:
                return "\(key): \(value)"
            }
        }.description
    }
}

extension Data {
    func asString() -> String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any],
            let jsonString = String(data: try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted), encoding: .utf8) {
            return jsonString
        }

        return map { String(format: "%02hhx", $0) }.joined()
    }
}
