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
        return Single.create { single -> Disposable in
            let sid = "CA7fad946f02195f0faa2b6c5f79207429"
            let url = URL(string: NexdClientAPI.basePath +  "/call/calls/\(sid)/record")!

            let task = self.urlSession.downloadTask(with: url) { localURL, urlResponse, error in
                guard let localURL = localURL else {
                    let error = error ?? CallsError.downloadFailed
                    single(.error(error))
                    return
                }

                log.debug("Saved audio file to: \(localURL)")
                single(.success(localURL))
            }

            task.resume()
            return Disposables.create()
        }

//        return CallsAPI.callsControllerGetCallUrl(sid: sid)
//            .asSingle()
    }
}
