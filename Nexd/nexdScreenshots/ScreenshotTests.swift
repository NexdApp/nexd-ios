//
//  nexdScreenshots.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import Swifter
import XCTest

class ScreenshotTests: XCTestCase {
    enum Constants {
        static let mockBackendPort: in_port_t = 9090
    }

    let mockBackend = HttpServer()
    var app: XCUIApplication?

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)

        mockBackend.notFoundHandler = { request in
            XCTFail("Unexpected request: \(request)")
            return HttpResponse.notFound
        }

        XCTAssertNoThrow(try? mockBackend.start(Constants.mockBackendPort))

        app.enableUiTesting()
        app.changeBaseUrl(to: "http://localhost:\(Constants.mockBackendPort)")

        self.app = app
    }

    override func tearDownWithError() throws {
        mockBackend.stop()
    }

    func testInitialScreen() {
        app?.logout()

        app?.launch()
        snapshot("initial")
    }

    func testLoginScreen() {
        app?.login()

        mockBackend.onGetProfile { () -> User? in
            User(firstName: "Maria", lastName: "Schultz", street: nil, number: nil, zipCode: nil, city: nil, id: "", email: nil, role: nil, phoneNumber: nil)
        }

        app?.launch()
        snapshot("login")
    }
}

extension XCUIApplication {
    func enableUiTesting() {
        add(argument: .uiTestingEnabled)
    }

    func disableUiTesting() {
        remove(argument: .uiTestingEnabled)
    }

    func login() {
        add(argument: .loginForTesting)
    }

    func logout() {
        add(argument: .logoutForTesting)
    }

    func changeBaseUrl(to url: String) {
        launchEnvironment[UiTestingVariables.baseUrl.rawValue] = url
    }

    private func add(argument: UiTestingArguments) {
        launchArguments += [argument.rawValue]
    }

    private func remove(argument: UiTestingArguments) {
        launchArguments = launchArguments.filter { $0 != argument.rawValue }
    }
}

extension HttpRequest: CustomStringConvertible {
    public var description: String {
        return "HttpRequest: \(method) - \(path)"
    }

    func queryParam(_ key: String) -> String? {
        return queryParams.filter { $0.0 == key }.map { $0.1 }.first
    }

    var jsonBody: String? {
        return String(bytes: body, encoding: .utf8)
    }

    func parseBody<T: Decodable>() -> T? {
        let decoder = JSONDecoder()

        return try? decoder.decode(T.self, from: Data(body))
    }
}

extension Encodable {
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var jsonString: String? {
        guard let data = jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }

    var byteArray: [UInt8]? {
        guard let data = jsonData else { return nil }
        return [UInt8](data)
    }
}

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
