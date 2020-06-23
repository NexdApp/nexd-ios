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
    let mockBackend = HttpServer()
    var app: XCUIApplication?

    var seekerRobot: SeekerReobot?

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()

        seekerRobot = SeekerReobot(app: app, mockBackend: mockBackend)

        setupSnapshot(app)

        mockBackend.notFoundHandler = { request in
            XCTFail("Unexpected request: \(request)")
            return HttpResponse.notFound
        }

        XCTAssertNoThrow(try? mockBackend.start(mockBackendPort))

        app.enableUiTesting()
        app.changeBaseUrl(to: "http://localhost:\(mockBackendPort)")

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

    func testHelperOptions() {
        app?.login()

        mockBackend
            .withDefaultUserProfile()

        app?.launch()

        app?.buttons[AccessibilityIdentifier.mainPageHelperButton.rawValue].tap()

        snapshot("HelperOptions")
    }

    func testHelperShoppingWorkflow() {
        app?.login()

        mockBackend
            .withDefaultUserProfile()
            .withDefaultUnits()
            .withDefaulHelpLists()
            .withDefaulHelpRequests()

        app?.launch()

        app?.buttons[AccessibilityIdentifier.mainPageHelperButton.rawValue].tap()
        app?.buttons[AccessibilityIdentifier.helperOptionsGoShoppingButton.rawValue].tap()

        snapshot("HelperRequestOverview")

        app?.buttons[AccessibilityIdentifier.helperRequestOverviewContinueButton.rawValue].tap()

        snapshot("ShoppingListView")

        app?.buttons[AccessibilityIdentifier.shoppingListContinueButton.rawValue].tap()

        snapshot("CheckoutView")

        app?.buttons[AccessibilityIdentifier.checkoutViewContinueButton.rawValue].tap()

        snapshot("DeliveryConfirmationView")
    }

    func testHelperCallTranscriptionWorkflow() {
        app?.login()

        mockBackend
            .withDefaultUserProfile()
            .withDefaultCalls()

        app?.launch()

        app?.buttons[AccessibilityIdentifier.mainPageHelperButton.rawValue].tap()
        app?.buttons[AccessibilityIdentifier.helperOptionsTranscribeCallButton.rawValue].tap()

        snapshot("Call transcription")
    }

    func testCreateHelpRequestFlow() {
        var articlesCalled: XCTestExpectation? = expectation(description: "Articles REST call")

        app?.login()

        mockBackend
            .withDefaultUserProfile()
            .withDefaultUnits()
            .withDefaultArticles { articlesCalled?.fulfill() }

        app?.launch()

        seekerRobot?.goToSeekerItemSelection()

        snapshot("SeekerItemSelection_empty")

        seekerRobot?.addItemButton.tap()

        snapshot("SeekerArticleInput_empty")

        let nameTextField = seekerRobot?.articleNameTextfield
        nameTextField?.tap()

        app?.dismissKeyboardSwipeIntroduction()

        nameTextField?.typeText("article_name_input".localized())

        waitForExpectations(timeout: 2.0, handler: nil)
        articlesCalled = nil

        snapshot("SeekerArticleInput_suggestions")

        app?.staticTexts[AccessibilityIdentifier.seekerArticleInputNameSuggestion.rawValue].firstMatch.tap()

        let amountTextField = seekerRobot?.articleAmountTextFfield
        amountTextField?.tap()
        amountTextField?.typeText("5")

        let unitButton = seekerRobot?.articleUnitButton
        unitButton?.tap()

        snapshot("SeekerArticleInput_unit_picker")

        let doneButton = app?.buttons[AccessibilityIdentifier.modalDoneButton.rawValue].firstMatch
        doneButton?.tap()

        snapshot("SeekerItemSelection_one_item")

        seekerRobot?.insertArticle(inputText: "b", articleNameStringId: "article_name_banana", unitId: 0, amount: "500")
        seekerRobot?.insertArticle(inputText: "a", articleNameStringId: "article_name_milk", unitId: 5, amount: "3")
        seekerRobot?.insertArticle(inputText: "a", articleNameStringId: "article_name_coffee", unitId: 3, amount: "1")
        seekerRobot?.insertArticle(inputText: "a", articleNameStringId: "article_name_water", unitId: 4, amount: "6")

        snapshot("SeekerItemSelection_multiple_items")
    }

    private var mockBackendPort: in_port_t {
        // use a different mock backend port for each simulator to avoid conflicts when tests run in parallel
        switch UIDevice.current.name {
        case "iPhone 8":
            return 9090
        case "iPhone 8 Plus":
            return 9091
        case "iPhone 11":
            return 9092
        case "iPhone 11 Pro Max":
            return 9093
        case "iPad Pro (12.9-inch) (2nd generation)":
            return 9094
        case "iPad Pro (12.9-inch) (4th generation)":
            return 9095
        default:
            XCTFail("No mock backend port specified for iOS device: \(UIDevice.current.name)")
            return 9999
        }
    }
}

extension XCUIApplication {
    func dismissKeyboardSwipeIntroduction() {
        if otherElements["UIContinuousPathIntroductionView"].exists {
            otherElements["UIContinuousPathIntroductionView"].descendants(matching: .button).firstMatch.tap()
        }
    }
}

struct SeekerReobot {
    let app: XCUIApplication
    let mockBackend: HttpServer

    var seekerButton: XCUIElement { app.buttons[AccessibilityIdentifier.mainPageSeekerButton.rawValue] }
    var addItemButton: XCUIElement { app.buttons[AccessibilityIdentifier.seekerItemSelectionAddButton.rawValue] }
    var articleNameTextfield: XCUIElement { app.textFields[AccessibilityIdentifier.seekerArticleInputNameTextField.rawValue].firstMatch }
    var articleAmountTextFfield: XCUIElement { app.textFields[AccessibilityIdentifier.seekerArticleInputAmountTextField.rawValue].firstMatch }
    var articleUnitButton: XCUIElement { app.buttons[AccessibilityIdentifier.seekerArticleInputUnitButton.rawValue].firstMatch }
    var articleInputDoneButton: XCUIElement { app.buttons[AccessibilityIdentifier.modalDoneButton.rawValue].firstMatch }

    func goToSeekerItemSelection() {
        seekerButton.tap()
    }

    func insertArticle(inputText: String, articleNameStringId: String, unitId: Int64, amount: String) {
        let articlesApiCalledExpectation = XCTestExpectation(description: "Articles API called")

        mockBackend.onGetArticles { _ -> [Article]? in
            defer {
                articlesApiCalledExpectation.fulfill()
            }

            return [ Article(id: 0,
                             name: articleNameStringId.localized(),
                             language: .current,
                             statusOverwritten: nil,
                             popularity: 0,
                             unitIdOrder: [unitId],
                             categoryId: nil,
                             status: nil,
                             category: nil) ]
        }

        addItemButton.tap()
        articleNameTextfield.tap()
        articleNameTextfield.typeText(inputText)

        _ = XCTWaiter.wait(for: [articlesApiCalledExpectation], timeout: 2.0)

        app.staticTexts[AccessibilityIdentifier.seekerArticleInputNameSuggestion.rawValue].firstMatch.tap()

        articleAmountTextFfield.tap()
        articleAmountTextFfield.typeText(amount)

        articleUnitButton.tap()

        articleInputDoneButton.tap()
    }
}
