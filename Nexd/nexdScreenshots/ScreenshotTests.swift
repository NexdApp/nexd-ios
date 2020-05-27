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
