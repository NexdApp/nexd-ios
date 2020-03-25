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
}

class DebuggableURLSessionRequestBuilderFactory: RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        return DebuggableURLSessionRequestBuilder<T>.self
    }

    func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type {
        return DebuggableURLSessionDecodableRequestBuilder<T>.self
    }
}

class DebuggableURLSessionRequestBuilder<T>: URLSessionRequestBuilder<T> {
    override func execute(_ apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, Error>) -> Void) {
        log.debug("\(method) - \(URLString)")
        super.execute(apiResponseQueue) { result in
            completion(result)
        }
    }
}

class DebuggableURLSessionDecodableRequestBuilder<T: Decodable>: URLSessionDecodableRequestBuilder<T> {
    override func execute(_ apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, Error>) -> Void) {
        log.debug("\(method) - \(URLString) - parameters: \(parameters)")
        super.execute(apiResponseQueue) { result in
            completion(result)
        }
    }
}
