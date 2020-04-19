//
//  ValidatingTextField.swift
//  Nexd
//
//  Created by Tobias Schröpf on 02.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit
import Validator

class ValidatingTextField: CustomView {
    enum State {
        case error(String?)
        case warning(String?)
        case normal
    }

    private var textField = TextField()
    private let errorLabel = UILabel()

    var value: String? {
        return textField.text
    }

    var state: State = .normal {
        didSet {
            switch state {
            case let .error(message):
                showError(text: message)

            case let .warning(message):
                showWarning(text: message)

            case .normal:
                showNormal()
            }
        }
    }

    override func setupView() {
        addSubview(textField)
        addSubview(errorLabel)
        errorLabel.textAlignment = .left
        errorLabel.numberOfLines = 2
    }

    override func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.left.right.equalToSuperview().inset(42)
        }
    }

    func validate() -> Bool {
        let result = textField.validate()
        textField.validationHandler?(result)
        return result.isValid
    }

    private func showNormal() {
        textField.showNormal()

        errorLabel.isHidden = true
        errorLabel.attributedText = nil
    }

    private func showError(text: String?) {
        textField.showError()

        errorLabel.isHidden = text == nil
        errorLabel.attributedText = text?.asErrorLabel()
    }

    private func showWarning(text: String?) {
        textField.showWarning()

        errorLabel.isHidden = text == nil
        errorLabel.attributedText = text?.asWarningLabel()
    }

    static func make(tag: Int,
                     placeholder: String? = nil,
                     icon: UIImage? = nil,
                     keyboardType: UIKeyboardType? = nil,
                     isSecureTextEntry: Bool? = nil,
                     autoCapitalizationType: UITextAutocapitalizationType = .sentences,
                     delegate: UITextFieldDelegate? = nil,
                     validationRules: ValidationRuleSet<String>? = nil) -> ValidatingTextField {
        let view = ValidatingTextField()

        view.textField.tag = tag
        view.textField.styled(placeholder: placeholder, icon: icon)

        if let keyboardType = keyboardType {
            view.textField.keyboardType = keyboardType
        }

        if let isSecureTextEntry = isSecureTextEntry {
            view.textField.isSecureTextEntry = isSecureTextEntry
        }

        view.textField.autocapitalizationType = autoCapitalizationType
        view.textField.autocorrectionType = .no
        view.textField.spellCheckingType = .no
        view.textField.delegate = delegate

        if let rules = validationRules {
            view.textField.validationRules = rules

            view.textField.validationHandler = { result in
                switch result {
                case .valid:
                    view.state = .normal
                case let .invalid(failureErrors):
                    let messages = failureErrors.map { $0.message }
                    view.state = .error(messages.first)
                }
            }
            view.textField.validateOnInputChange(enabled: true)
        }

        return view
    }
}
