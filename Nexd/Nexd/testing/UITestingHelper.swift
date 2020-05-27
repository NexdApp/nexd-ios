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

            log.debug("UI Testing is enabled!")
        }
    }
#endif


extension ProcessInfo {
    #if DEBUG
    var isUiTestingEnabled: Bool {
        ProcessInfo.processInfo.arguments.contains(UiTestingArguments.uiTestingEnabled.rawValue)
    }
    #endif

    var baseUrl: String? {
        ProcessInfo.processInfo.environment[UiTestingVariables.baseUrl.rawValue]
    }
}
