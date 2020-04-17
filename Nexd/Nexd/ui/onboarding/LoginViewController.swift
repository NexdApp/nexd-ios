//
//  LoginViewController.swift
//  nexd
//
//  Created by Julian Manke on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import NexdClient
import RxSwift
import SnapKit
import UIKit
import Validator

class LoginViewController: ViewController<LoginViewController.ViewModel> {
    struct ViewModel {
        let navigator: ScreenNavigating
    }

    private let disposeBag = DisposeBag()
    private var keyboardObserver: KeyboardObserver?
    private var keyboardDismisser: KeyboardDismisser?

    private lazy var scrollView = UIScrollView()

    private lazy var logo = UIImageView()
    private lazy var email = ValidatingTextField.make(tag: 0,
                                                      placeholder: R.string.localizable.login_placeholder_username(),
                                                      keyboardType: .emailAddress,
                                                      delegate: self,
                                                      validationRules: .email())

    private lazy var password = ValidatingTextField.make(tag: 1,
                                                         placeholder: R.string.localizable.login_placeholder_password(),
                                                         isSecureTextEntry: true,
                                                         delegate: self,
                                                         validationRules: .password())
    private lazy var loginButton = UIButton()

    private lazy var usernameImageView = UIImageView()

    private lazy var passwordImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardDismisser = KeyboardDismisser(rootView: view)

        setupImageViews()

        view.backgroundColor = .white
        title = R.string.localizable.login_screen_title()

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

        contentView.addSubview(logo)
        logo.image = R.image.logo()
        logo.snp.makeConstraints { make -> Void in
            make.size.equalTo(Style.logoSize)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(68)
        }

        contentView.addSubview(email)
        email.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(logo.snp.bottom).offset(134)
        }

        contentView.addSubview(usernameImageView)
        usernameImageView.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(email.snp_centerY).offset(-7.5)
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.right.equalToSuperview().offset(-41)
        }

        contentView.addSubview(password)
        password.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(email.snp_bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(passwordImageView)
        passwordImageView.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(password.snp_centerY).offset(-7.5)
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.right.equalToSuperview().offset(-41)
        }

        contentView.addSubview(loginButton)
        loginButton.style(text: R.string.localizable.login_button_title_login())
        loginButton.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(password.snp_bottom).offset(Style.verticalPadding)
            make.bottom.equalToSuperview()
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

    override func bind(viewModel: LoginViewController.ViewModel, disposeBag: DisposeBag) {

    }

    fileprivate func setupImageViews() {
        usernameImageView.image = R.image.person1()
        usernameImageView.contentMode = .scaleAspectFit

        passwordImageView.image = R.image.lock2()
        passwordImageView.contentMode = .scaleAspectFit
    }
}

extension LoginViewController {
    @objc func loginButtonPressed(sender: UIButton!) {
        let hasInvalidInput = [email, password]
            .map { $0.validate() }
            .contains(false)

        guard !hasInvalidInput else {
            log.warning("Cannot login user! Validation failed!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        guard let email = email.value, let password = password.value else {
            log.warning("Missing mandatory login information!")
            return
        }

        AuthenticationService.shared.login(email: email, password: password)
            .subscribe(onCompleted: { [weak self] in
                log.debug("Login successful!")
                self?.viewModel?.navigator.toMainScreen()
            }, onError: { [weak self] error in
                log.error("Login failed: \(error)")
                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_login_failed())
            })
            .disposed(by: disposeBag)
    }

    @objc func registerButtonPressed(sender: UIButton!) {
        viewModel?.navigator.toRegistrationScreen()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag)

        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }

        return false
    }
}

private extension ValidationRuleSet where InputType == String {
    enum ValidationErrors: String, ValidationError {
        case emailInvalid = "Email address is invalid"
        case passwordTooShort = "Password is too short!"
        var message: String { return rawValue }
    }

    static func email() -> ValidationRuleSet<String> {
        ValidationRuleSet(rules: [ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationErrors.emailInvalid)])
    }

    static func password() -> ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRuleLength(min: 5, error: ValidationErrors.passwordTooShort)])
    }
}
