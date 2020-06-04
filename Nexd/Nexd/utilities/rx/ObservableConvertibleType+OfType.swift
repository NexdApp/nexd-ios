//
//  ObservableConvertibleType+OfType.swift
//  nexd
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift

extension ObservableConvertibleType {
    func ofType<R>() -> RxSwift.Observable<R> {
        return of(type: R.self)
    }

    func of<R>(type: R.Type) -> RxSwift.Observable<R> {
        return Observable.create { observer in
            let subscription = self.asObservable().subscribe { event in
                switch event {
                case let .next(value):
                    if let typeValue = value as? R {
                        observer.on(.next(typeValue))
                    }

                case let .error(error):
                    observer.on(.error(error))

                case .completed:
                    observer.on(.completed)
                }
            }

            return subscription
        }
    }
}
