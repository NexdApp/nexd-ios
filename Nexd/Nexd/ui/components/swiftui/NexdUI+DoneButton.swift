//
//  NexdUI+DoneButton.swift
//  nexd
//
//  Created by Tobias Schröpf on 30.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct DoneButtonModifier: ViewModifier {
    let text: Text
    let identifier: AccessibilityIdentifier
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(NexdUI.Buttons.done(text: text, action: action).padding(20).identified(by: identifier), alignment: .topTrailing)

    }
}

extension View {
    func withDoneButton(text: Text = R.string.localizable.done_button_title.text, identifier: AccessibilityIdentifier = .doneButton, action: @escaping (() -> Void)) -> some View {
        ModifiedContent(content: self, modifier: DoneButtonModifier(text: text, identifier: identifier, action: action))
    }
}
