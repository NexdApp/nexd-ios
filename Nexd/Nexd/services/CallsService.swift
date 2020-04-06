//
//  CallsService.swift
//  nexd
//
//  Created by Tobias Schröpf on 05.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient
import RxSwift

enum CallsError: Error {
    case downloadFailed
}

class CallsService {
    static let shared = CallsService()

    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [ "Authorization": "Bearer \(Storage.shared.authorizationToken ?? "-")" ]
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()

    func allCalls() -> Single<[Call]> {
        return CallsAPI.callsControllerCalls()
            .asSingle()
    }

    func callFileUrl(sid: String) -> Single<URL> {
        return CallsAPI.callsControllerGetCallUrl(sid: sid)
            .asSingle()
    }
}
