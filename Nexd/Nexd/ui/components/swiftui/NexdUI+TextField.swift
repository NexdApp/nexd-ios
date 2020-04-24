//
//  UITextField+NexdUI.swift
//  nexd
//
//  Created by Tobias Schröpf on 14.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI
import UIKit
import Validator

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

        static func make(tag: Int, placeholder: String?, onChanged: ((String) -> Void)?, onCommit: ((String?) -> Void)?) -> WrappableTextField {
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
    }

    struct InputValidation {
        let rules: ValidationRuleSet<String>
        let handler: (ValidationResult) -> Void
    }

    struct TextField: UIViewRepresentable {
        var tag: Int = 0
        var placeholder: String?
        var onChanged: ((String) -> Void)?
        var onCommit: ((String?) -> Void)?
        var inputValidation: InputValidation?

        func makeUIView(context: UIViewRepresentableContext<TextField>) -> WrappableTextField {
            var textField = WrappableTextField.make(tag: tag,
                                                    placeholder: placeholder,
                                                    onChanged: onChanged,
                                                    onCommit: onCommit)

            if let inputValidation = inputValidation {
                textField.validationRules = inputValidation.rules
                textField.validationHandler = inputValidation.handler
                textField.validateOnInputChange(enabled: true)
            }

            return textField
        }

        func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<TextField>) {
            uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
    }

    struct ValidatingTextField: View {
        var tag: Int = 0
        var placeholder: String?
        var onChanged: ((String) -> Void)?
        var onCommit: ((String?) -> Void)?
        var inputValidation: InputValidation?

        var body: some View {
            VStack {
                NexdUI.TextField(tag: tag,
                                 placeholder: placeholder,
                                 onChanged: onChanged,
                                 onCommit: onCommit,
                                 inputValidation: inputValidation)

                Text("ERROR MESSAGE HERE PLEASE")
                    .font(R.font.proximaNovaSoftBold.font(size: 12))
                    .foregroundColor(R.color.errorTint.color)
            }
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
