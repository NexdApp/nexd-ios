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
    static let shared = AuthenticationService()

    func register(email: String, firstName: String, lastName: String, password: String) -> Single<ResponseTokenDto> {
        return AuthenticationAPI.authControllerRegister(registerPayload: RegisterPayload(email: email, firstName: firstName, lastName: lastName, role: .helper, password: password))
            .asSingle()
            .flatMap { [weak self] response -> Single<ResponseTokenDto> in
                guard let self = self else { return Single.just(response) }
                return self.userDidAuthenticate(accessToken: response.accessToken, userId: response.id)
                    .andThen(Single.just(response))
            }
    }

    func login(email: String, password: String) -> Completable {
        return AuthenticationAPI.authControllerLogin(loginPayload: LoginPayload(email: email, password: password))
            .asSingle()
            .flatMapCompletable { [weak self] response in
                guard let self = self else { return Completable.empty() }
                return self.userDidAuthenticate(accessToken: response.accessToken, userId: response.id)
            }
    }

    func userDidAuthenticate(accessToken: String, userId: Int) -> Completable {
        Completable.from {
            NexdClientAPI.setup(authorizationToken: accessToken)
            Storage.shared.authorizationToken = accessToken
            Storage.shared.userId = userId
        }
    }

    func logout() {
        Storage.shared.userId = nil
        Storage.shared.authorizationToken = nil
        NexdClientAPI.setup(authorizationToken: nil)
    }
}
