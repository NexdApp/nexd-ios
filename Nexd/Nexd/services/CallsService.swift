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

class CallsService {
    static let shared = CallsService()

    func allCalls() -> Single<[Call]> {
        return CallsAPI.callsControllerCalls()
            .asSingle()
    }
}
