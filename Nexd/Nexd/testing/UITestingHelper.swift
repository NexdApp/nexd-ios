//
//  UITestingHelper.swift
//  nexd
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

#if DEBUG
enum UiTestingArguments: String {
    case uiTestingEnabled = "UI_TESTING_ENABLED"
}

enum UiTestingVariables: String {
    case uiTestingEnabled = "UI_TESTING_ENABLED"
}
#endif

extension ProcessInfo {
    var isUiTestingEnabled: Bool {
        ProcessInfo.processInfo.arguments.contains(UiTestingArguments.uiTestingEnabled.rawValue)
    }
}
