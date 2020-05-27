//
//  UITestingHelper.swift
//  nexd
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

#if DEBUG
    enum UITestingHelper {
        static func setupUiTestingIfNecessary() {
            guard ProcessInfo.processInfo.isUiTestingEnabled else {
                return
            }

            if ProcessInfo.processInfo.isLoggedInForTesting {
                UserDefaults.standard.setValue("TESTING_ONLY", forKey: "authorizationToken")
            }

            if ProcessInfo.processInfo.isLoggedOutForTesting {
                UserDefaults.standard.removeObject(forKey: "authorizationToken")
            }

            log.debug("UI Testing is enabled!")
        }
    }
#endif

extension ProcessInfo {
    #if DEBUG
    var isUiTestingEnabled: Bool {
        ProcessInfo.processInfo.arguments.contains(UiTestingArguments.uiTestingEnabled.rawValue)
    }

    var isLoggedInForTesting: Bool {
        ProcessInfo.processInfo.arguments.contains(UiTestingArguments.loginForTesting.rawValue)
    }

    var isLoggedOutForTesting: Bool {
        ProcessInfo.processInfo.arguments.contains(UiTestingArguments.logoutForTesting.rawValue)
    }
    #endif

    var baseUrl: String? {
        ProcessInfo.processInfo.environment[UiTestingVariables.baseUrl.rawValue]
    }
}
