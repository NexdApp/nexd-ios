//
//  UiTestingArguments.swift
//  nexd
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation

#if DEBUG
enum UiTestingArguments: String {
    case uiTestingEnabled = "UI_TESTING_ENABLED"
    case loginForTesting = "LOGIN_FOR_TESTING"
    case logoutForTesting = "LOGOUT_FOR_TESTING"
}
#endif
