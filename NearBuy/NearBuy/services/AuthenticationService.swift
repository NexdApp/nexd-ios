//
//  AuthenticateService.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import SwaggerClient
import RxSwift

class AuthenticationService {
    static let shared = AuthenticationService()

    func register(email: String, firstName: String, lastName: String, password: String) -> Single<ResponseTokenDto> {
        return AuthenticationAPI.authControllerRegister(body: RegisterPayload(email: email, firstName: firstName, lastName: lastName, role: .helper, password: password))
            .asSingle()
    }

    func login(email: String, password: String) -> Single<ResponseTokenDto> {
        return AuthenticationAPI.authControllerLogin(body: LoginPayload(email: email, password: password))
            .asSingle()
    }
}
