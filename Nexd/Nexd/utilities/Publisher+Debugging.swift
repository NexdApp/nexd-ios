//
//  Publisher+Debugging.swift
//  nexd
//
//  Created by Tobias Schröpf on 16.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine

extension Publisher {
    func debug(message: String = "") -> Publishers.HandleEvents<Self> {
        handleEvents(receiveSubscription: { subscription in log.debug("receiveSubscription: \(subscription)") },
                     receiveOutput: { output in log.debug("receiveOutput: \(output)") },
                     receiveCompletion: { error in log.debug("receiveCompletion: \(error)") },
                     receiveCancel: { log.debug("receiveCancel") },
                     receiveRequest: { demand in log.debug("receiveRequest: \(demand)") })
    }
}
