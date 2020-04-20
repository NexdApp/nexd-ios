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

    init(keyboardWillShow: KeyboardWillShowCallback? = nil,
         keyboardWillHide: KeyboardWillHideCallback? = nil) {
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

    static func insetting(scrollView: UIScrollView) -> KeyboardObserver {
        return KeyboardObserver(keyboardWillShow: { keyboardSize in
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height - 150, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets

            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }, keyboardWillHide: { _ in
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        })
    }
}
