//
//  View+Accessibility.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 27.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

extension View {
    func identified(by identifier: AccessibilityIdentifier) -> some View {
        accessibility(identifier: identifier.rawValue)
    }
}
