//
//  AuthenticateService.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import SwaggerClient

class AuthenticationService {
    static let shared = AuthenticationService()

    func register(email: String, firstName: String, lastName: String, password: String) {
        AuthenticationAPI.authControllerRegister(body: RegisterPayload(email: email, firstName: firstName, lastName: lastName, password: password)) { _, error in
            guard error == nil else {
                log.error("User registration failed: \(error)")
                return
            }

            log.debug("User registration successful")
        }
    }
}
