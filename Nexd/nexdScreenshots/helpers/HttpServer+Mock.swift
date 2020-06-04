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
}

extension HttpServer {
    @discardableResult
    func withDefaultUserProfile(file: StaticString = #file, line: UInt = #line) -> HttpServer {
        onGetProfile { User(firstName: "Maria", lastName: "Schultz", street: nil, number: nil, zipCode: "34032", city: nil, id: "", email: nil, role: nil, phoneNumber: nil) }
    }

    @discardableResult
    func withDefaultUnits(file: StaticString = #file, line: UInt = #line) -> HttpServer {
        onGetUnits { language -> [NexdClient.Unit]? in
            switch language {
            case "de":
                return [
                    NexdClient.Unit(id: 0, nameShort: "kg", language: .de, defaultOrder: nil, nameZero: "Kilogramm", nameOne: "Kilogramm", nameTwo: "Kilogramm", nameFew: "Kilogramm", nameMany: "Kilogramm", nameOther: "Kilogramm"),
                    NexdClient.Unit(id: 1, nameShort: "g", language: .de, defaultOrder: nil, nameZero: "Gramm", nameOne: "Gramm", nameTwo: "Gramm", nameFew: "Gramm", nameMany: "Gramm", nameOther: "Gramm"),
                    NexdClient.Unit(id: 2, nameShort: "Stk.", language: .de, defaultOrder: nil, nameZero: "Stück", nameOne: "Stück", nameTwo: "Stück", nameFew: "Stück", nameMany: "Stück", nameOther: "Stück"),
                    NexdClient.Unit(id: 3, nameShort: "Pkg.", language: .de, defaultOrder: nil, nameZero: "Packung", nameOne: "Packung", nameTwo: "Packung", nameFew: "Packung", nameMany: "Packung", nameOther: "Packung"),
                    NexdClient.Unit(id: 4, nameShort: "Fl.", language: .de, defaultOrder: nil, nameZero: "Flasche", nameOne: "Flasche", nameTwo: "Flasche", nameFew: "Flasche", nameMany: "Flasche", nameOther: "Flasche"),
                    NexdClient.Unit(id: 5, nameShort: "l", language: .de, defaultOrder: nil, nameZero: "Liter", nameOne: "Liter", nameTwo: "Liter", nameFew: "Liter", nameMany: "Liter", nameOther: "Liter")
                ]

            case "en":
                return [
                    NexdClient.Unit(id: 0, nameShort: "kg", language: .en, defaultOrder: nil, nameZero: "kilogram", nameOne: "kilogram", nameTwo: "kilogram", nameFew: "kilogram", nameMany: "kilogram", nameOther: "kilogram"),
                    NexdClient.Unit(id: 1, nameShort: "gr.", language: .en, defaultOrder: nil, nameZero: "grams", nameOne: "grams", nameTwo: "grams", nameFew: "grams", nameMany: "grams", nameOther: "grams"),
                    NexdClient.Unit(id: 2, nameShort: "pc.", language: .en, defaultOrder: nil, nameZero: "piece", nameOne: "piece", nameTwo: "piece", nameFew: "piece", nameMany: "piece", nameOther: "piece"),
                    NexdClient.Unit(id: 3, nameShort: "pack.", language: .en, defaultOrder: nil, nameZero: "package", nameOne: "package", nameTwo: "package", nameFew: "package", nameMany: "package", nameOther: "package"),
                    NexdClient.Unit(id: 3, nameShort: "pack.", language: .en, defaultOrder: nil, nameZero: "package", nameOne: "package", nameTwo: "package", nameFew: "package", nameMany: "package", nameOther: "package")
                ]

            default:
                XCTFail("Unexpected language: \(language ?? "nil")", file: file, line: line)
                return nil
            }
        }
    }

    @discardableResult
    func withDefaultArticles(file: StaticString = #file, line: UInt = #line, onCalled: (() -> Void)? = nil) -> HttpServer {
        onGetArticles { language -> [Article]? in
            defer { onCalled?() }

            switch language {
            case "de":
                return [
                    Article(id: 0, name: "Apfel", language: .de, statusOverwritten: nil, popularity: 0, unitIdOrder: [2], categoryId: nil, status: nil, category: nil),
                    Article(id: 3, name: "Apfelmuss", language: .de, statusOverwritten: nil, popularity: 1, unitIdOrder: [3], categoryId: nil, status: nil, category: nil),
                    Article(id: 4, name: "Apfelsaft", language: .de, statusOverwritten: nil, popularity: 2, unitIdOrder: [4, 5], categoryId: nil, status: nil, category: nil),
                    Article(id: 5, name: "Apfelringe", language: .de, statusOverwritten: nil, popularity: 3, unitIdOrder: [3], categoryId: nil, status: nil, category: nil)
                ]

            case "en":
                return [
                    Article(id: 0, name: "Apple", language: .en, statusOverwritten: nil, popularity: 0, unitIdOrder: [2], categoryId: nil, status: nil, category: nil),
                    Article(id: 1, name: "Apple juice", language: .en, statusOverwritten: nil, popularity: 1, unitIdOrder: [4, 5], categoryId: nil, status: nil, category: nil),
                    Article(id: 1, name: "Apple pie", language: .en, statusOverwritten: nil, popularity: 2, unitIdOrder: [2], categoryId: nil, status: nil, category: nil)
                ]

            default:
                XCTFail("Unexpected language: \(language ?? "nil")", file: file, line: line)
                return nil
            }
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
