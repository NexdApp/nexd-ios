//
//  XCUIApplication+Mock.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import XCTest

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
