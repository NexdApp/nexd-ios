//
//  KeyboardObserver.swift
//  Nexd
//
//  Created by Tobias Schröpf on 29.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class KeyboardObserver {
    typealias KeyboardWillShowCallback = (CGRect) -> Void
    typealias KeyboardWillHideCallback = (CGRect) -> Void

    private let keyboardWillShow: KeyboardWillShowCallback?
    private let keyboardWillHide: KeyboardWillHideCallback?

    init(keyboardWillShow: KeyboardWillShowCallback? = nil, keyboardWillHide: KeyboardWillHideCallback? = nil) {
        self.keyboardWillShow = keyboardWillShow
        self.keyboardWillHide = keyboardWillHide

        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onKeyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        keyboardWillShow?(keyboardSize)
    }

    @objc func onKeyboardWillHide(notification: NSNotification) {
        keyboardWillHide?(.zero)
    }
}
