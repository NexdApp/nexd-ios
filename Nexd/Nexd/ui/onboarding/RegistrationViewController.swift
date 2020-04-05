//
//  ViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import RxSwift
import SnapKit
import UIKit
import Validator

class RegistrationViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var keyboardObserver: KeyboardObserver?
    private var keyboardDismisser: KeyboardDismisser?

    lazy var scrollView = UIScrollView()

    lazy var email = ValidatingTextField.make(tag: 0,
                                              placeholder: R.string.localizable.registration_placeholer_email(),
                                              keyboardType: .emailAddress,
                                              validationRules: .email())

    lazy var firstName = ValidatingTextField.make(tag: 1,
                                                  placeholder: R.string.localizable.registration_placeholer_firstname(),
                                                  validationRules: .firstName())

    lazy var lastName = ValidatingTextField.make(tag: 2,
                                                 placeholder: R.string.localizable.registration_placeholer_lastname(),
                                                 validationRules: .lastName())

    lazy var password = ValidatingTextField.make(tag: 3,
                                                 placeholder: R.string.localizable.registration_placeholer_password(),
                                                 isSecureTextEntry: true,
                                                 validationRules: .password())

    lazy var confirmPassword = ValidatingTextField.make(tag: 4,
                                                        placeholder: R.string.localizable.registration_placeholer_confirm_password(),
                                                        isSecureTextEntry: true,
                                                        validationRules: .passwordConfirmation(dynamicTarget: { [weak self] in self?.password.value ?? "" }))

    lazy var registerButton = UIButton()

    lazy var privacyPolicy = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardDismisser = KeyboardDismisser(rootView: view)

        view.backgroundColor = .white
        title = R.string.localizable.registration_screen_title()

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(view)
        }

        contentView.addSubview(email)
        email.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.topMargin.equalTo(50)
        }

        contentView.addSubview(firstName)
        firstName.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(email.snp.bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(lastName)
        lastName.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(firstName.snp.bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(password)
        password.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(lastName.snp.bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(confirmPassword)
        confirmPassword.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(password.snp.bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(registerButton)
        registerButton.style(text: R.string.localizable.registration_button_title_continue())
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(confirmPassword.snp.bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(privacyPolicy)
        privacyPolicy.backgroundColor = .clear
        privacyPolicy.isScrollEnabled = false
        privacyPolicy.textContainerInset = .zero

        let term = R.string.localizable.registration_term_privacy_policy()
        let formatted = R.string.localizable.registration_label_privacy_policy_agreement(term)
        privacyPolicy.attributedText = formatted.asLink(range: formatted.range(of: term), target: "https://www.nexd.app/privacypage")
        privacyPolicy.snp.makeConstraints { make -> Void in
            make.height.equalTo(54)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(registerButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-Style.verticalPadding)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver = KeyboardObserver.insetting(scrollView: scrollView)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardObserver = nil
    }
}

extension RegistrationViewController {
    @objc func registerButtonPressed(sender: UIButton!) {
        let hasInvalidInput = [email, firstName, lastName, password, confirmPassword]
            .map { $0.validate() }
            .contains(false)

        guard !hasInvalidInput else {
            log.warning("Cannot register user! Validation failed!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        guard let email = email.value, let firstName = firstName.value, let lastName = lastName.value, let password = password.value else {
            log.warning("Cannot register user, mandatory field is missing!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        log.debug("Send registration to backend")
        AuthenticationService.shared.register(email: email,
                                              firstName: firstName,
                                              lastName: lastName,
                                              password: password)
            .subscribe(onCompleted: { [weak self] in
                log.debug("User registration successful")
                let userDetailsVC = UserDetailsViewController()
                userDetailsVC.userInformation = UserDetailsViewController.UserInformation(firstName: firstName, lastName: lastName)
                self?.navigationController?.pushViewController(userDetailsVC, animated: true)
            }, onError: { [weak self] error in
                log.error("User registration failed: \(error)")

                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
            })
            .disposed(by: disposeBag)
    }
}

private extension ValidationRuleSet where InputType == String {
    enum ValidationErrors: String, ValidationError {
        case emailInvalid = "Email address is invalid!"
        case missingFirstName = "Frist name must not be empty!"
        case missingLastName = "Last name must not be empty!"
        case passwordTooShort = "Password is too short!"
        case passwordConfirmationFailed = "Passwords do not match!"
        var message: String { return rawValue }
    }

    static func email() -> ValidationRuleSet<String> {
        ValidationRuleSet(rules: [ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationErrors.emailInvalid)])
    }

    static func firstName() -> ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRuleLength(min: 1, error: ValidationErrors.missingFirstName)])
    }

    static func lastName() -> ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRuleLength(min: 1, error: ValidationErrors.missingLastName)])
    }

    static func password() -> ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRuleLength(min: 5, error: ValidationErrors.passwordTooShort)])
    }

    static func passwordConfirmation(dynamicTarget: @escaping (() -> String)) -> ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRuleEquality<String>(dynamicTarget: dynamicTarget,
                                                                         error: ValidationErrors.passwordConfirmationFailed)])
    }
}
