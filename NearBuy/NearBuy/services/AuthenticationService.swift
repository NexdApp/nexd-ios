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

    private let disposeBat = DisposeBag()

    func register(email: String, firstName: String, lastName: String, password: String) {
        AuthenticationAPI.authControllerRegister(body: RegisterPayload(email: email, firstName: firstName, lastName: lastName, password: password))
            .subscribe(onError: { error in
                log.error("User registration failed: \(error)")
            }) {
                log.debug("User registration successful")
        }
    }
}
