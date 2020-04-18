//
//  UITextField+NexdUI.swift
//  nexd
//
//  Created by Tobias Schröpf on 14.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI
import UIKit

extension NexdUI {
    class WrappableTextField: UITextField, UITextFieldDelegate {
        var textFieldChangedHandler: ((String) -> Void)?
        var onCommitHandler: ((String?) -> Void)?

        private let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentValue = textField.text as NSString? {
                let proposedValue = currentValue.replacingCharacters(in: range, with: string) as String
                textFieldChangedHandler?(proposedValue)
            }
            return true
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            onCommitHandler?(textField.text)
        }

        open override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        open override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
    }

    struct TextField: UIViewRepresentable {
        var tag: Int = 0
        var placeholder: String?
        var onChanged: ((String) -> Void)?
        var onCommit: ((String?) -> Void)?

        func makeUIView(context: UIViewRepresentableContext<TextField>) -> WrappableTextField {
            let textField = WrappableTextField()

            textField.font = R.font.proximaNovaSoftBold(size: 22.0)
            textField.backgroundColor = .white
            textField.tintColor = .black
            textField.textColor = .black
            textField.attributedPlaceholder = placeholder?.asPlaceholder()

            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true

            textField.tag = tag
            textField.delegate = textField
            textField.onCommitHandler = onCommit
            textField.textFieldChangedHandler = onChanged

            return textField
        }

        func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<TextField>) {
            uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
    }
}

#if DEBUG
    struct TextField_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                NexdUI.TextField(placeholder: "Placeholder")
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
