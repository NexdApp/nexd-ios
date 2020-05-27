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

        app.launch()

        self.app = app
    }

    override func tearDownWithError() throws {
        mockBackend.stop()
    }

    func testInitialScreen() {
        mockBackend.onLogin { dto -> User? in
            return nil
        }

        sleep(50000)
        snapshot("initial")
    }
}

extension XCUIApplication {
    func enableUiTesting() {
        launchArguments += [UiTestingArguments.uiTestingEnabled.rawValue]
    }

    func disableUiTesting() {
        launchArguments = launchArguments.filter { $0 != UiTestingArguments.uiTestingEnabled.rawValue }
    }

    func changeBaseUrl(to url: String) {
        launchEnvironment[UiTestingVariables.baseUrl.rawValue] = url
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
}
