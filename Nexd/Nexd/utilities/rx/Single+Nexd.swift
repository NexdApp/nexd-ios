//
//  Single+Nexd.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import NexdClient

extension PrimitiveSequence {
    func onApiErrors(handler: @escaping ((ErrorResponse) -> Void)) -> PrimitiveSequence<Trait, Element> {
        return catchError { error -> PrimitiveSequence<Trait, Element> in
            if let errorResponse = error as? ErrorResponse {
                handler(errorResponse)
            }

            return self
        }
    }
}
