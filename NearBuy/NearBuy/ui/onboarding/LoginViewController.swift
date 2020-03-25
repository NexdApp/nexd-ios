//
//  ViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import NexdClient
import UIKit

class LoginViewController: UIViewController {
    enum Style {
        static let buttonBackgroundColor: UIColor = .gray
        static let logoSize = CGSize(width: 256, height: 256)
        static let buttonHeight: CGFloat = 52
    }

    private let disposeBag = DisposeBag()

    lazy var gradient = GradientView()
    lazy var logo = UIImageView()
    lazy var username = TextField()
    lazy var password = TextField()
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

        view.addSubview(logo)
        logo.image = R.image.logo()
        logo.snp.makeConstraints { make -> Void in
            make.size.equalTo(Style.logoSize)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(16)
        }

        view.addSubview(username)
        username.keyboardType = .emailAddress
        username.styled(placeholder: R.string.localizable.login_placeholer_username())
        username.snp.makeConstraints { make -> Void in
            make.height.equalTo(36)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(logo.snp.bottom).offset(16)
        }

        view.addSubview(password)
        password.styled(placeholder: R.string.localizable.login_placeholer_password())
        password.isSecureTextEntry = true
        password.snp.makeConstraints { make -> Void in
            make.height.equalTo(36)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(username.snp_bottom).offset(16)
        }

        view.addSubview(loginButton)
        loginButton.style(text: R.string.localizable.login_button_title_login())
        loginButton.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(password.snp_bottom).offset(16)
        }

        view.addSubview(registerButton)
        registerButton.style(text: R.string.localizable.login_button_title_register())
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
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
