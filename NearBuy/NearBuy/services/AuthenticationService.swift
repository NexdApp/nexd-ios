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

    func register(email: String, firstName: String, lastName: String, password: String) -> Completable {
        AuthenticationAPI.authControllerRegister(body: RegisterPayload(email: email, firstName: firstName, lastName: lastName, role: .helper, password: password))
            .ignoreElements()
    }

    func login(email: String, password: String) -> Completable {
        return AuthenticationAPI.authControllerLogin(body: LoginPayload(email: email, password: password))
            .ignoreElements()
    }
}
