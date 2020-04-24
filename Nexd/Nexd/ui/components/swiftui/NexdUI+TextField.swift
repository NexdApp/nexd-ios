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

        static func make(tag: Int,
                         placeholder: String?,
                         onChanged: ((String) -> Void)?,
                         onCommit: ((String?) -> Void)?,
                         inputConfiguration: InputConfiguration?) -> WrappableTextField {
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

            inputConfiguration?.apply(to: textField)

            return textField
        }
    }

    struct InputValidation {
        let rules: ValidationRuleSet<String>
        let handler: (ValidationResult) -> Void
    }

    struct InputConfiguration {
        var keyboardType: UIKeyboardType = .default
        var autocapitalizationType: UITextAutocapitalizationType = .sentences
        var autocorrectionType: UITextAutocorrectionType = .default
        var spellCheckingType: UITextSpellCheckingType = .default

        func apply(to textField: UITextField) {
            textField.keyboardType = keyboardType
            textField.autocapitalizationType = autocapitalizationType
            textField.autocorrectionType = autocorrectionType
            textField.spellCheckingType = spellCheckingType
        }
    }

    struct TextField: UIViewRepresentable {
        var tag: Int = 0
        var placeholder: String?
        var onChanged: ((String) -> Void)?
        var onCommit: ((String?) -> Void)?
        var inputValidation: InputValidation?
        var inputConfiguration: InputConfiguration?

        func makeUIView(context: UIViewRepresentableContext<TextField>) -> WrappableTextField {
            var textField = WrappableTextField.make(tag: tag,
                                                    placeholder: placeholder,
                                                    onChanged: onChanged,
                                                    onCommit: onCommit,
                                                    inputConfiguration: inputConfiguration)

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
        @State private var errorMessage: String?

        var tag: Int = 0
        var placeholder: String?
        var onChanged: ((String) -> Void)?
        var onCommit: ((String?) -> Void)?
        var validationRules: ValidationRuleSet<String>?
        var inputConfiguration: InputConfiguration?

        private var inputValidation: InputValidation? {
            guard let rules = validationRules else { return nil }

            return InputValidation(rules: rules,
                                   handler: { result in
                                       switch result {
                                       case .valid:
                                           self.errorMessage = nil
                                       case let .invalid(failureErrors):
                                           let messages = failureErrors.map { $0.message }
                                           self.errorMessage = messages.first
                                       }
            })
        }

        var body: some View {
            VStack {
                errorMessage.map { errorMessage in
                    Text(errorMessage)
                        .font(R.font.proximaNovaSoftBold.font(size: 12))
                        .foregroundColor(R.color.errorTint.color)
                }

                NexdUI.TextField(tag: tag,
                                 placeholder: placeholder,
                                 onChanged: onChanged,
                                 onCommit: onCommit,
                                 inputValidation: inputValidation,
                                 inputConfiguration: inputConfiguration)
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
