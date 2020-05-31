//
//  NexdUI+CancelButton.swift
//  nexd
//
//  Created by Tobias Schröpf on 30.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct CancelButtonModifier: ViewModifier {
    let text: Text
    let identifier: AccessibilityIdentifier
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(NexdUI.Buttons.cancel(text: text, action: action).padding(20).identified(by: identifier), alignment: .topLeading)
    }
}

extension View {
    func withCancelButton(text: Text = R.string.localizable.cancel_button_title.text, identifier: AccessibilityIdentifier = .cancelButton, action: @escaping (() -> Void)) -> some View {
        ModifiedContent(content: self, modifier: CancelButtonModifier(text: text, identifier: identifier, action: action))
    }
}
