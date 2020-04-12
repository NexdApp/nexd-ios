//
//  OpenAPI+Nexd.swift
//  Nexd
//
//  Created by Tobias Schröpf on 25.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient
import NVActivityIndicatorView

extension NexdClientAPI {
    static func setup(authorizationToken: String?) {
        #if DEBUG
            NexdClientAPI.requestBuilderFactory = DebuggableRequestBuilderFactory()
        #endif

        if let baseUrl = AppConfiguration.baseUrl {
            NexdClientAPI.basePath = baseUrl
        }

        if let token = authorizationToken {
            #if DEBUG
                log.verbose("Using token: Bearer \(token)")
            #endif

            NexdClientAPI.customHeaders = ["Authorization": "Bearer \(token)"]
        }
    }

    static func requestStarted<T>(request: RequestBuilder<T>) {
        if !NVActivityIndicatorPresenter.sharedInstance.isAnimating {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(message: R.string.localizable.loading_overlay_message(),
                                                                                    messageFont: R.font.proximaNovaSoftBold(size: 24),
                                                                                    type: .pacman,
                                                                                    color: R.color.darkButtonText(),
                                                                                    displayTimeThreshold: 500,
                                                                                    minimumDisplayTime: 200,
                                                                                    backgroundColor: .clear,
                                                                                    textColor: R.color.darkButtonText()))
        }

        log.debug("Start request: \(request)")

        if let parametersDescription = request.parametersDescription {
            log.debug("Parameters: \(parametersDescription)")
        }
    }

    static func requestFinished<T>(result: Result<Response<T>, Error>) {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

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

private class DebuggableRequestBuilderFactory: RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        return DebuggableURLSessionRequestBuilder<T>.self
    }

    func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type {
        return DebuggableDecodableRequestBuilder<T>.self
    }
}

private class DebuggableURLSessionRequestBuilder<T>: URLSessionRequestBuilder<T> {
    override func execute(_ apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, Error>) -> Void) {
        NexdClientAPI.requestStarted(request: self)

        super.execute(apiResponseQueue) { result in
            NexdClientAPI.requestFinished(result: result)
            completion(result)
        }
    }
}

private class DebuggableDecodableRequestBuilder<T: Decodable>: URLSessionDecodableRequestBuilder<T> {
    override func execute(_ apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, Error>) -> Void) {
        NexdClientAPI.requestStarted(request: self)

        super.execute(apiResponseQueue) { result in
            NexdClientAPI.requestFinished(result: result)
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
            case let data as Data:
                return "\(key): \(data.asString())"
            default:
                return "\(key): \(value)"
            }
        }.description
    }
}

extension Data {
    func asString() -> String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []) {
            return String(describing: json)
        }

        return map { String(format: "%02hhx", $0) }.joined()
    }
}
