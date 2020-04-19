//
//  ValidationRuleSet+Nexd.swift
//  nexd
//
//  Created by Tobias Schröpf on 18.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import PhoneNumberKit
import Validator

extension ValidationRuleSet where InputType == String {
    enum ValidationErrors: String, ValidationError {
        case emailInvalid
        case missingFirstName
        case missingLastName
        case passwordTooShort
        case passwordConfirmationFailed
        case phoneNumberInvalid
        case zipCodeInvalid
        var message: String {
            switch self {
            case .emailInvalid:
                return R.string.localizable.error_message_registration_invalid_email()

            case .missingFirstName:
                return R.string.localizable.error_message_registration_field_missing()

            case .missingLastName:
                return R.string.localizable.error_message_registration_field_missing()

            case .passwordTooShort:
                return R.string.localizable.error_message_registration_password_too_short()

            case .passwordConfirmationFailed:
                return R.string.localizable.error_message_registration_password_match()

            case .phoneNumberInvalid:
                return R.string.localizable.error_message_input_validation_phone_number_invalid()

            case .zipCodeInvalid:
                return R.string.localizable.error_message_input_validation_zip_code_invalid()
            }
        }
    }

    static var email: ValidationRuleSet<String> {
        ValidationRuleSet(rules: [ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationErrors.emailInvalid)])
    }

    static var password: ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRuleLength(min: 8, error: ValidationErrors.passwordTooShort)])
    }

    static var firstName: ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRuleLength(min: 1, error: ValidationErrors.missingFirstName)])
    }

    static var lastName: ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRuleLength(min: 1, error: ValidationErrors.missingLastName)])
    }

    static func passwordConfirmation(dynamicTarget: @escaping (() -> String)) -> ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRuleEquality<String>(dynamicTarget: dynamicTarget,
                                                                         error: ValidationErrors.passwordConfirmationFailed)])
    }

    static var phone: ValidationRuleSet<String> {
        let phoneNumberKit = PhoneNumberKit()
        return ValidationRuleSet<String>(rules: [ValidationRuleCondition(error: ValidationErrors.phoneNumberInvalid, condition: { phoneNumber -> Bool in
            guard let phoneNumber = phoneNumber else { return false}
            return phoneNumberKit.isValidPhoneNumber(phoneNumber)
        })])

    }

    static var zipCode: ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRulePattern(pattern: "^[0-9]+$", error: ValidationErrors.zipCodeInvalid)])
    }
}
