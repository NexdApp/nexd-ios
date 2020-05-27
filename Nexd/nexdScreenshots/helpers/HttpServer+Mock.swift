//
//  HttpServer+Mock.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import Swifter

extension HttpServer {
    typealias EmailAddress = String
    typealias Password = String

    func onLogin(_ handler: @escaping (LoginDto?) -> User?) {
        POST["/auth/login"] = { request in
            let body = try? JSONDecoder().decode(LoginDto.self, from: Data(request.body))
            guard let response = handler(body) else { return .notFound }

            return .ok(.text(response.jsonString ?? ""))
        }
    }

    func onGetProfile(_ handler: @escaping () -> User?) {
        GET["/users/me"] = { request in
            guard let response = handler() else { return .notFound }

            return .ok(.text(response.jsonString ?? ""))
        }
    }
}
