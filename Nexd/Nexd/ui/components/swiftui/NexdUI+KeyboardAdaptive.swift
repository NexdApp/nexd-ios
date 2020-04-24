//
//  NexdUI+KeyboardAdaptive.swift
//  nexd
//
//  Created by Tobias Schröpf on 14.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import SwiftUI

/// Inspired by: https://www.vadimbulavin.com/how-to-move-swiftui-view-when-keyboard-covers-text-field/
extension Publishers {
    static var keyboardFrame: AnyPublisher<CGRect?, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardDidShowNotification)
            .map { notification -> CGRect? in notification.keyboardFrame }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ -> CGRect? in nil }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardFrame: CGRect? {
        return userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0

    func body(content: Content) -> some View {
            content
                .offset(x: 0, y: -self.bottomPadding)
                .onReceive(Publishers.keyboardFrame) { keyboardFrame in
                    guard let keyboardFrame = keyboardFrame else {
                        self.bottomPadding = 0
                        return
                    }

                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    self.bottomPadding += max(0, focusedTextInputBottom - keyboardFrame.minY)
                }
                .animation(.easeOut(duration: 0.16))
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder?

    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}
