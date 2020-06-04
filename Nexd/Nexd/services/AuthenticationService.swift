//
//  AuthenticateService.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient
import RxSwift

class AuthenticationService {
    private var storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    func register(email: String, firstName: String?, lastName: String?, password: String) -> Completable {
        let dto = RegisterDto(email: email, firstName: firstName, lastName: lastName, phoneNumber: nil, password: password)
        return AuthAPI.authControllerRegister(registerDto: dto)
            .asSingle()
            .flatMapCompletable { [weak self] response -> Completable in
                guard let self = self else { return Completable.empty() }
                return self.userDidAuthenticate(accessToken: response.accessToken)
            }
    }

    func login(email: String, password: String) -> Completable {
        return AuthAPI.authControllerLogin(loginDto: LoginDto(email: email, password: password))
            .asSingle()
            .flatMapCompletable { [weak self] response in
                guard let self = self else { return Completable.empty() }
                return self.userDidAuthenticate(accessToken: response.accessToken)
            }
    }

    private func userDidAuthenticate(accessToken: String) -> Completable {
        Completable.from { [weak self] in
            NexdClientAPI.setup(authorizationToken: accessToken)
            self?.storage.authorizationToken = accessToken
        }
    }

    func logout() {
        storage.authorizationToken = nil
        NexdClientAPI.setup(authorizationToken: nil)
    }
}
