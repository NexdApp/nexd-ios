//
//  ViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

class LoginViewController: UIViewController {
    enum Style {
        static let buttonBackgroundColor: UIColor = .gray
    }

    private let disposeBag = DisposeBag()

    lazy var gradient = GradientView()
    lazy var username = UITextField()
    lazy var password = UITextField()
    lazy var loginButton = UIButton()
    lazy var registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = R.string.localizable.login_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(username)
        username.placeholder = R.string.localizable.login_placeholer_username()

        username.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.topMargin.equalTo(50)
        }

        view.addSubview(password)
        password.placeholder = R.string.localizable.login_placeholer_password()
        password.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(username.snp_bottom).offset(16)
        }

        view.addSubview(loginButton)
        loginButton.backgroundColor = Style.buttonBackgroundColor
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.setTitle(R.string.localizable.login_button_title_login(), for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(password.snp_bottom).offset(16)
        }

        view.addSubview(registerButton)
        registerButton.backgroundColor = Style.buttonBackgroundColor
        
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true

        registerButton.setTitle(R.string.localizable.login_button_title_register(), for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(loginButton.snp_bottom).offset(16)
        }
    }
}

extension LoginViewController {
    @objc func loginButtonPressed(sender: UIButton!) {
        guard let email = username.text, let password = password.text else {
            log.warning("Missing mandatory login information!")
            return
        }

        AuthenticationService.shared.login(email: email, password: password)
            .subscribe(onCompleted: { [weak self] in
                log.debug("Login successful!")
                Storage.shared.loggedInUserEmail = email
                self?.navigationController?.pushViewController(SelectRoleViewController(), animated: true)
            }) { [weak self] error in
                log.error("Login failed: \(error)")
                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_login_failed())
            }
            .disposed(by: disposeBag)
    }

    @objc func registerButtonPressed(sender: UIButton!) {
        let registrationVC = RegistrationViewController()
        registrationVC.onRegistrationFinished = { [weak self] result in
            self?.username.text = result.email
            self?.password.text = result.password
            self?.navigationController?.popViewController(animated: true)
        }

        navigationController?.pushViewController(registrationVC, animated: true)
    }
}
