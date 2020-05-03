//
//  UITextField+Nexd.swift
//  Nexd
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UITextField {
    func underline() {
        let bottomBorder = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = R.color.textfieldStroke()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)

        // MARK: Setup Anchors

        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
    }

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
