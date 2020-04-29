//
//  UITextField+Nexd.swift
//  Nexd
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UITextField {
    func addInputAccessory(hasPrevious: Bool = false, hasNext: Bool = false, hasDone: Bool = true) {
        guard hasPrevious || hasNext || hasDone else { return }

        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        var items = [UIBarButtonItem]()

        if hasPrevious {
            let previousButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(goToPreviousView))
            items.append(previousButton)
        }

        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))

        if hasNext {
            let nextButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(goToNextView))
            items.append(nextButton)
        }

        if hasDone {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIView.endEditing))
            items.append(doneButton)
        }

        toolbar.setItems(items, animated: false)
        inputAccessoryView = toolbar
    }

    @objc
    func goToNextView() {
        guard let control = superview?.superview?.viewWithTag(tag + 1) as? UIControl else {
            resignFirstResponder()
            return
        }

        control.becomeFirstResponder()
    }

    @objc
    func goToPreviousView() {
        guard let control = superview?.superview?.viewWithTag(tag - 1) as? UIControl else {
            resignFirstResponder()
            return
        }

        control.becomeFirstResponder()
    }
}
