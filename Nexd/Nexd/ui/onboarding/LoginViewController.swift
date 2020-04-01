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

class LoginViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var keyboardObserver: KeyboardObserver?
    private var keyboardDismisser: KeyboardDismisser?

    lazy var gradient = GradientView()
    lazy var scrollView = UIScrollView()

    lazy var logo = UIImageView()
    lazy var username = TextField()
    lazy var password = TextField()
    lazy var loginButton = UIButton()
    lazy var registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardDismisser = KeyboardDismisser(rootView: view)

        view.backgroundColor = .white
        title = R.string.localizable.login_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
            make.topMargin.equalTo(Style.verticalPadding)
        }

        contentView.addSubview(username)
        username.keyboardType = .emailAddress
        username.styled(placeholder: R.string.localizable.login_placeholer_username())
        username.tag = 0
        username.delegate = self
        username.snp.makeConstraints { make -> Void in
            make.height.equalTo(36)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(logo.snp.bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(password)
        password.styled(placeholder: R.string.localizable.login_placeholer_password())
        password.isSecureTextEntry = true
        password.tag = 1
        password.delegate = self
        password.snp.makeConstraints { make -> Void in
            make.height.equalTo(36)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(username.snp_bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(loginButton)
        loginButton.style(text: R.string.localizable.login_button_title_login())
        loginButton.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(password.snp_bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(registerButton)
        registerButton.style(text: R.string.localizable.login_button_title_register())
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(loginButton.snp_bottom).offset(Style.verticalPadding)
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

extension LoginViewController {
    @objc func loginButtonPressed(sender: UIButton!) {
        guard let email = username.text, let password = password.text else {
            log.warning("Missing mandatory login information!")
            return
        }

        AuthenticationService.shared.login(email: email, password: password)
            .subscribe(onSuccess: { [weak self] response in
                log.debug("Login successful!")

                NexdClientAPI.customHeaders = ["Authorization": "Bearer \(response.accessToken)"]

                Storage.shared.authorizationToken = response.accessToken
                Storage.shared.userId = response.id
                self?.navigationController?.pushViewController(SelectRoleViewController(), animated: true)
            }, onError: { [weak self] error in
                log.error("Login failed: \(error)")
                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_login_failed())
            })
            .disposed(by: disposeBag)
    }

    @objc func registerButtonPressed(sender: UIButton!) {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
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
