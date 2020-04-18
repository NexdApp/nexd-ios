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

        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()

    func numbers() -> Single<[PhoneNumberDto]> {
        return PhoneAPI.phoneControllerGetNumbers()
            .asSingle()
    }

    func allCalls() -> Single<[Call]> {
        log.error("NOT IMPLEMENTED YET!!")
        return Single.error(CallsError.downloadFailed)
//        return CallsAPI.callsControllerCalls()
//            .asSingle()
    }

    func downloadCallFile(sid: String) -> Single<URL> {
        guard let documentsUrl = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            log.error("Cannot create download URL path!")
            return Single.error(CallsError.downloadFailed)
        }

        let destinationUrl = documentsUrl.appendingPathComponent("\(sid).wav")
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            log.debug("file already exists [\(destinationUrl.path)]")
            return Single.just(destinationUrl)
        }

        guard let url = URL(string: "\(NexdClientAPI.basePath)/call/calls/\(sid)/record") else {
            return Single.error(CallsError.downloadFailed)
        }

        return Downloader(localUrl: destinationUrl).loadFile(url: url, to: destinationUrl)
    }
}

enum DownloaderError: Error {
    case missingAuthorizationToken
    case invalidUrl
    case downloadFailed
}

typealias DownloadHandler = (URL?, URLResponse?, Error?) -> Void

class Downloader: NSObject {
    private let delegateQueue = OperationQueue()
    private let resultSubject = PublishSubject<URL>()
    private let localUrl: URL

    init(localUrl: URL) {
        delegateQueue.qualityOfService = .utility

        self.localUrl = localUrl
    }

    func loadFile(url: URL, to localUrl: URL) -> Single<URL> {
        guard let bearerToken = PersistentStorage.shared.authorizationToken else {
            return Single.error(DownloaderError.missingAuthorizationToken)
        }

        let delegateQueue = OperationQueue()
        delegateQueue.qualityOfService = .utility

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer \(bearerToken)", "accept": "audio/x-wav"]
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: delegateQueue)
        let request = URLRequest(url: url)

        return Single.create { single -> Disposable in
            log.debug("Downloading file from: \(url)")
            let task = session.downloadTask(with: request) { tempLocalUrl, response, error in
                log.debug("Complete - response: \(response.debugDescription), error: \(error?.localizedDescription ?? "-")")

                if let error = error {
                    log.error("Download failed: \(error)")
                    single(.error(error))
                    return
                }

                guard let tempLocalUrl = tempLocalUrl, error == nil else {
                    log.error("No file was saved!")
                    single(.error(DownloaderError.downloadFailed))
                    return
                }

                log.debug("File was saved to: \(tempLocalUrl)")

                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    log.error("Cannot check status code")
                    single(.error(DownloaderError.downloadFailed))
                    return
                }

                guard statusCode < 400 else {
                    log.error("Failed, status code: \(statusCode)")
                    single(.error(DownloaderError.downloadFailed))
                    return
                }

                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    single(.success(localUrl))
                } catch let writeError {
                    log.debug("error writing file \(localUrl) : \(writeError)")
                    single(.error(DownloaderError.downloadFailed))
                }
            }
            task.resume()
            return Disposables.create()
        }
    }
}

extension Downloader: URLSessionDelegate {
    // Handle redirect!
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        log.debug("willPerformHTTPRedirection")
        let task = session.downloadTask(with: request) { _, response, error in
            log.debug("Complete - response: \(response.debugDescription), error: \(error?.localizedDescription ?? "-")")
            completionHandler(request)
        }
        task.resume()
    }
}
