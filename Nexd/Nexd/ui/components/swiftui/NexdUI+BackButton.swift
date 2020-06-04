//
//  NexdUI+BackButton.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
    let text: Text
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(NexdUI.Buttons.back(text: text, action: action)
            .padding(20), alignment: .topLeading)
    }
}

extension View {
    func withBackButton(text: Text = R.string.localizable.back_button_title.text, action: @escaping (() -> Void)) -> some View {
        ModifiedContent(content: self, modifier: BackButtonModifier(text: text, action: action))
    }
}
