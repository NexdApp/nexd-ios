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
        snapshot("Initial")
    }

    func testMainScreen() {
        app?.login()

        mockBackend
            .withDefaultUserProfile()

        app?.launch()
        snapshot("MainPage")
    }

    func testHelperOverviewScreen() {
        app?.login()

        mockBackend
            .withDefaultUserProfile()

        app?.launch()

        app?.buttons[AccessibilityIdentifier.mainPageHelperButton.rawValue].tap()

        snapshot("HelperOverview")
    }

    func testCreateHelpRequestFlow() {
        let articlesCalled = expectation(description: "Articles REST call")

        app?.login()

        mockBackend
            .withDefaultUserProfile()
            .withDefaultUnits()
            .withDefaultArticles { articlesCalled.fulfill() }

        app?.launch()

        app?.buttons[AccessibilityIdentifier.mainPageSeekerButton.rawValue].tap()

        snapshot("SeekerItemSelection_empty")

        app?.buttons[AccessibilityIdentifier.seekerItemSelectionAddButton.rawValue].tap()

        snapshot("SeekerArticleInput_empty")

        let nameTextField = app?.textFields[AccessibilityIdentifier.seekerArticleInputNameTextField.rawValue].firstMatch
        nameTextField?.tap()
        nameTextField?.typeText("Ap")

        waitForExpectations(timeout: 2.0, handler: nil)

        snapshot("SeekerArticleInput_suggestions")

        app?.staticTexts[AccessibilityIdentifier.seekerArticleInputNameSuggestion.rawValue].firstMatch.tap()

        let amountTextField = app?.textFields[AccessibilityIdentifier.seekerArticleInputAmountTextField.rawValue].firstMatch
        amountTextField?.tap()
        amountTextField?.typeText("5")

        let unitButton = app?.buttons[AccessibilityIdentifier.seekerArticleInputUnitButton.rawValue].firstMatch
        unitButton?.tap()

        snapshot("SeekerArticleInput_unit_picker")

        let doneButton = app?.buttons[AccessibilityIdentifier.modalDoneButton.rawValue].firstMatch
        doneButton?.tap()

        snapshot("SeekerItemSelection_one_item")
    }
}
