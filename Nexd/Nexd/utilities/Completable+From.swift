//
//  Completable+From.swift
//  Nexd
//
//  Created by Tobias Schröpf on 03.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift

extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Swift.Never {
    static func from(_ closure: @escaping () -> Void) -> Completable {
        return Completable.create { completable in
            closure()
            completable(.completed)
            return Disposables.create()
        }
    }
}
