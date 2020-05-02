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

class PhoneService {
    static let shared = PhoneService()

    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default

        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()

    func numbers() -> Single<[PhoneNumberDto]> {
        return PhoneAPI.phoneControllerGetNumbers()
            .asSingle()
    }

    func oneCall() -> Single<Call?> {
        PhoneAPI.phoneControllerGetCalls(limit: 1, converted: false)
            .map { $0.first }
            .asSingle()
    }

    func convertCallToHelpRequest(sid: String, dto: HelpRequestCreateDto) -> Single<Call> {
        PhoneAPI.phoneControllerConverted(sid: sid, helpRequestCreateDto: dto)
            .asSingle()
    }
}
