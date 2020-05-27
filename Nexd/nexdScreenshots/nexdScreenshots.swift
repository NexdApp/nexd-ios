//
//  nexdScreenshots.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import XCTest

class nexdScreenshots: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialScreen() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        snapshot("initial")
    }
}

extension XCUIApplication {
    func enableUiTesting() {
        launchArguments += [UiTestingArguments.uiTestingEnabled.rawValue]
    }

    func disableUiTesting() {
        
    }
}
