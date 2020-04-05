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
        let dto = CallQueryDto(amount: nil, country: nil, zip: nil, city: nil, converted: nil)
        return CallsAPI.callsControllerCalls(callQueryDto: dto)
            .asSingle()
    }
}
