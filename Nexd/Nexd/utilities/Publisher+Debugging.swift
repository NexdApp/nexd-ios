//
//  Publisher+Debugging.swift
//  nexd
//
//  Created by Tobias Schröpf on 16.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine

extension Publisher {
    func debug(_ identifier: String = "", file: StaticString = #file, line: Int = #line, function: StaticString = #function) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveSubscription: { subscription in
            log.debug("[\(identifier)] receiveSubscription: \(subscription)", functionName: function, fileName: file, lineNumber: line)
        }, receiveOutput: { output in
            log.debug("[\(identifier)] receiveOutput: \(output)", functionName: function, fileName: file, lineNumber: line)
        }, receiveCompletion: { error in
            log.debug("[\(identifier)] receiveCompletion: \(error)", functionName: function, fileName: file, lineNumber: line)
        }, receiveCancel: {
            log.debug("[\(identifier)] receiveCancel", functionName: function, fileName: file, lineNumber: line)
        }, receiveRequest: { demand in
            log.debug("[\(identifier)] receiveRequest: \(demand)", functionName: function, fileName: file, lineNumber: line)
        })
    }
}
