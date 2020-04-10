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

class StartAuthenticationFlowViewController: ViewController<StartAuthenticationFlowViewController.ViewModel> {
    class ViewModel {
        fileprivate let navigator: ScreenNavigating

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }
    }

    private let disposeBag = DisposeBag()
    private var keyboardObserver: KeyboardObserver?
    private var keyboardDismisser: KeyboardDismisser?

    private lazy var scrollView = UIScrollView()

    private lazy var logo = UIImageView()
//    private lazy var email = ValidatingTextField.make(tag: 0,
//                                                      placeholder: R.string.localizable.login_placeholder_username(),
//                                                      keyboardType: .emailAddress,
//                                                      delegate: self,
//                                                      validationRules: .email())

//    private lazy var password = ValidatingTextField.make(tag: 1,
//                                                         placeholder: R.string.localizable.login_placeholder_password(),
//                                                         isSecureTextEntry: true,
//                                                         delegate: self,
//                                                         validationRules: .password())
    private lazy var loginButton = UIButton()
    private lazy var registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardDismisser = KeyboardDismisser(rootView: view)

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
            make.topMargin.equalTo(170)
        }

//        contentView.addSubview(email)
//        email.snp.makeConstraints { make -> Void in
//            make.left.equalToSuperview().offset(8)
//            make.right.equalToSuperview().offset(-8)
//            make.top.equalTo(logo.snp.bottom).offset(Style.verticalPadding)
//        }
//
//        contentView.addSubview(password)
//        password.snp.makeConstraints { make -> Void in
//            make.left.equalToSuperview().offset(8)
//            make.right.equalToSuperview().offset(-8)
//            make.top.equalTo(email.snp_bottom).offset(Style.verticalPadding)
//        }

        contentView.addSubview(loginButton)
        loginButton.style(text: R.string.localizable.login_button_title_login())
        loginButton.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(logo.snp_bottom).offset(100)
        }

        contentView.addSubview(registerButton)
        registerButton.style(text: R.string.localizable.login_button_title_register())
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(loginButton.snp_bottom).offset(34)
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

    override func bind(viewModel: StartAuthenticationFlowViewController.ViewModel, disposeBag: DisposeBag) {
        
    }
}

extension StartAuthenticationFlowViewController {
    @objc func loginButtonPressed(sender: UIButton!) {
        self.viewModel?.navigator.toLoginScreen()
    }

    @objc func registerButtonPressed(sender: UIButton!) {
        self.viewModel?.navigator.toRegistrationScreen()
    }
}

//extension StartAuthenticationFlowViewController: UITextFieldDelegate {
////    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        let nextTag = textField.tag + 1
////        // Try to find next responder
////        let nextResponder = textField.superview?.viewWithTag(nextTag)
////
////        if nextResponder != nil {
////            // Found next responder, so set it
////            nextResponder?.becomeFirstResponder()
////        } else {
////            // Not found, so remove keyboard
////            textField.resignFirstResponder()
////        }
////
////        return false
////    }
//}

//private extension ValidationRuleSet where InputType == String {
//    enum ValidationErrors: String, ValidationError {
//        case emailInvalid = "Email address is invalid"
//        case passwordTooShort = "Password is too short!"
//        var message: String { return rawValue }
//    }
//
//    static func email() -> ValidationRuleSet<String> {
//        ValidationRuleSet(rules: [ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationErrors.emailInvalid)])
//    }
//
//    static func password() -> ValidationRuleSet<String> {
//        ValidationRuleSet<String>(rules: [ValidationRuleLength(min: 5, error: ValidationErrors.passwordTooShort)])
//    }
//}
