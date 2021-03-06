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
    enum TextFieldStyle {
        case `default`
        case onboarding

        func apply(to textField: WrappableTextField) {
            textField.font = R.font.proximaNovaBold(size: 22.0)
            textField.tintColor = .black
            textField.textColor = .black

            switch self {
            case .default:
                textField.backgroundColor = .white
                textField.layer.cornerRadius = 10
                textField.clipsToBounds = true

            case .onboarding:
                textField.backgroundColor = .clear
                textField.underline()
            }
        }
    }

    class WrappableTextField: UITextField, UITextFieldDelegate {
        var textFieldChangedHandler: ((String?) -> Void)?
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

        func textFieldDidEndEditing(_ textField: UITextField) {
            onCommitHandler?(textField.text)
        }

        open override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rightViewSize = rightView?.bounds.size ?? .zero

            return CGRect(x: bounds.origin.x + padding.left,
                          y: bounds.origin.y + padding.top,
                          width: bounds.size.width - padding.left - padding.right - rightViewSize.width - 8,
                          height: bounds.size.height - padding.top - padding.bottom)
        }

        open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return textRect(forBounds: bounds)
        }

        open override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return textRect(forBounds: bounds)
        }

        override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            guard let size = rightView?.bounds.size else { return .zero }

            return CGRect(x: bounds.maxX - size.width - padding.right,
                          y: (bounds.height / 2) - (size.height / 2),
                          width: size.width,
                          height: size.height)
        }

        @objc internal func onEditingChanged(_ sender: UITextField) {
            textFieldChangedHandler?(sender.text)
        }

        static func make(style: TextFieldStyle,
                         tag: Int,
                         placeholder: String?,
                         icon: UIImage? = nil,
                         onChanged: ((String?) -> Void)?,
                         onCommit: ((String?) -> Void)?,
                         inputConfiguration: InputConfiguration?) -> WrappableTextField {
            let textField = WrappableTextField()
            textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            textField.attributedPlaceholder = placeholder?.asPlaceholder()

            style.apply(to: textField)

            textField.tag = tag
            textField.delegate = textField
            textField.onCommitHandler = onCommit
            textField.textFieldChangedHandler = onChanged

            if let icon = icon {
                let imageView = UIImageView(image: icon.withRenderingMode(.alwaysTemplate))
                imageView.sizeToFit()
                textField.rightViewMode = .always
                textField.rightView = imageView
            }

            inputConfiguration?.apply(to: textField)

            textField.addTarget(textField, action: #selector(onEditingChanged), for: .editingChanged)

            return textField
        }
    }

    struct InputValidation {
        let rules: ValidationRuleSet<String>
        let handler: (ValidationResult) -> Void
    }

    struct InputConfiguration {
        var isSecureTextEntry: Bool = false
        var keyboardType: UIKeyboardType = .default
        var autocapitalizationType: UITextAutocapitalizationType = .sentences
        var autocorrectionType: UITextAutocorrectionType = .default
        var spellCheckingType: UITextSpellCheckingType = .default
        var returnKeyType: UIReturnKeyType = .default
        var hasPrevious: Bool = false
        var hasNext: Bool = false
        var hasDone: Bool = false

        func apply(to textField: UITextField) {
            textField.isSecureTextEntry = isSecureTextEntry
            textField.keyboardType = keyboardType
            textField.autocapitalizationType = autocapitalizationType
            textField.autocorrectionType = autocorrectionType
            textField.spellCheckingType = spellCheckingType
            textField.returnKeyType = returnKeyType

            textField.addInputAccessory(hasPrevious: hasPrevious, hasNext: hasNext, hasDone: hasDone)
        }
    }

    struct TextField: UIViewRepresentable {
        var style: TextFieldStyle = .default
        var tag: Int = 0
        @Binding var text: String?
        var placeholder: String?
        var icon: UIImage?
        var onChanged: ((String?) -> Void)?
        var onCommit: ((String?) -> Void)?
        var inputValidation: InputValidation?
        var inputConfiguration: InputConfiguration?

        func makeUIView(context: UIViewRepresentableContext<TextField>) -> WrappableTextField {
            var textField = WrappableTextField.make(style: style,
                                                    tag: tag,
                                                    placeholder: placeholder,
                                                    icon: icon,
                                                    onChanged: { string in
                                                        // swiftformat:disable redundantSelf
                                                        self.text = string
                                                        self.onChanged?(string)
                                                        // swiftformat:enable redundantSelf
                                                    },
                                                    onCommit: onCommit,
                                                    inputConfiguration: inputConfiguration)

            if let inputValidation = inputValidation {
                textField.validationRules = inputValidation.rules
                textField.validationHandler = inputValidation.handler
                textField.validateOnInputChange(enabled: true)
                textField.validateOnEditingEnd(enabled: true)
            }

            return textField
        }

        func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<TextField>) {
            uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)

            uiView.text = text
        }
    }

    struct ValidatingTextField: View {
        @State private var errorMessage: String?

        var style: TextFieldStyle = .default
        var tag: Int = 0
        @Binding var text: String?
        var placeholder: String?
        var icon: UIImage?
        var onChanged: ((String?) -> Void)?
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
                NexdUI.TextField(style: style,
                                 tag: tag,
                                 text: $text,
                                 placeholder: placeholder,
                                 icon: icon,
                                 onChanged: onChanged,
                                 onCommit: onCommit,
                                 inputValidation: inputValidation,
                                 inputConfiguration: inputConfiguration)
                    .overlay(
                        errorMessage.map { errorMessage in
                            VStack {
                                Text(errorMessage)
                                    .font(R.font.proximaNovaBold.font(size: 12))
                                    .foregroundColor(R.color.errorTint.color)
                                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .bottomLeading)
                                    .padding([.leading, .trailing], 8)
                            }
                            .background(Color.white)
                            .opacity(0.8)
                            .padding([.leading, .trailing], 12)
                            .offset(y: -30)
                        }, alignment: .top
                    )
            }
        }
    }
}

#if DEBUG
    struct TextField_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                NexdUI.TextField(text: Binding.constant("Test"), placeholder: "Placeholder")
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
