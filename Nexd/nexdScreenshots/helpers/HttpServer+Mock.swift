//
//  HttpServer+Mock.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import Swifter
import XCTest

extension HttpServer {
    typealias Language = String

    @discardableResult
    func onLogin(_ handler: @escaping (LoginDto?) -> User?) -> HttpServer {
        POST["/auth/login"] = { request in
            let body = try? JSONDecoder().decode(LoginDto.self, from: Data(request.body))
            guard let response = handler(body) else { return .notFound }

            return .ok(.text(response.jsonString ?? ""))
        }

        return self
    }

    @discardableResult
    func onGetProfile(_ handler: @escaping () -> User?) -> HttpServer {
        GET["/users/me"] = { request in
            guard let response = handler() else { return .notFound }

            return .ok(.text(response.jsonString ?? ""))
        }

        return self
    }

    @discardableResult
    func onGetUnits(_ handler: @escaping (Language?) -> [NexdClient.Unit]?) -> HttpServer {
        GET["/article/units"] = { request in
            let language = request.queryParam("language")

            guard let response = handler(language) else { return .notFound }

            return .ok(.text(response.jsonString ?? ""))
        }

        return self
    }

    @discardableResult
    func onGetArticles(_ handler: @escaping (Language?) -> [Article]?) -> HttpServer {
        GET["/article/articles"] = { request in
            let language = request.queryParam("language")

            guard let response = handler(language) else { return .notFound }

            return .ok(.text(response.jsonString ?? ""))
        }

        return self
    }

    @discardableResult
    func onGetCalls(_ handler: @escaping () -> [Call]?) -> HttpServer {
        GET["/phone/calls"] = { request in
            guard let response = handler() else { return .notFound }

            return .ok(.text(response.jsonString ?? ""))
        }

        return self
    }

    @discardableResult
    func onGetHelpLists(_ handler: @escaping () -> [HelpList]?) -> HttpServer {
        GET["/help-lists"] = { request in
            guard let response = handler() else { return .notFound }

            return .ok(.text(response.jsonString ?? ""))
        }

        return self
    }

    @discardableResult
    func onGetHelpRequests(_ handler: @escaping () -> [HelpRequest]?) -> HttpServer {
        GET["/help-requests"] = { request in
            guard let response = handler() else { return .notFound }

            return .ok(.text(response.jsonString ?? ""))
        }

        return self
    }
}

extension HttpServer {
    @discardableResult
    func withDefaultUserProfile(file: StaticString = #file, line: UInt = #line) -> HttpServer {
        onGetProfile { User(firstName: "Maria", lastName: "Schultz", street: nil, number: nil, zipCode: "34032", city: nil, id: "", email: nil, role: nil, phoneNumber: nil) }
    }

    @discardableResult
    func withDefaultUnits(file: StaticString = #file, line: UInt = #line) -> HttpServer {
        onGetUnits { language -> [NexdClient.Unit]? in
            MockData.shared.units
        }
    }

    @discardableResult
    func withDefaultArticles(file: StaticString = #file, line: UInt = #line, onCalled: (() -> Void)? = nil) -> HttpServer {
        onGetArticles { language -> [Article]? in
            defer { onCalled?() }

            return MockData.shared.articles
        }
    }

    @discardableResult
    func withDefaulHelpRequests(file: StaticString = #file, line: UInt = #line, onCalled: (() -> Void)? = nil) -> HttpServer {
        onGetHelpRequests { () -> [HelpRequest]? in
        defer { onCalled?() }

        return MockData.shared.helpRequests
        }
    }

    @discardableResult
    func withDefaulHelpLists(file: StaticString = #file, line: UInt = #line, onCalled: (() -> Void)? = nil) -> HttpServer {
        onGetHelpLists { () -> [HelpList]? in
        defer { onCalled?() }

        return MockData.shared.helpLists
        }
    }

    @discardableResult
    func withDefaultCalls(file: StaticString = #file, line: UInt = #line, onCalled: (() -> Void)? = nil) -> HttpServer {
        onGetCalls {
            defer { onCalled?() }

            return [
                Call(convertedHelpRequestId: 0,
                     sid: "sid",
                     createdAt: Date(),
                     updatedAt: Date(),
                     recordingUrl: nil,
                     phoneNumber: nil,
                     country: nil,
                     zip: nil,
                     city: nil,
                     converterId: nil,
                     converter: nil)
            ]
        }
    }
}
