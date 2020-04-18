//
//  NexdUI+KeyboardDismissing.swift
//  nexd
//
//  Created by Tobias Schröpf on 16.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI
import UIKit

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture { UIApplication.shared.endEditing() }
    }
}

extension View {
    func dismissingKeyboard() -> some View {
        ModifiedContent(content: self, modifier: DismissingKeyboard())
    }
}
