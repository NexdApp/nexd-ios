//
//  ViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SnapKit
import UIKit

class LoginViewController: UIViewController {
    enum Style {
        static let buttonBackgroundColor: UIColor = .gray
    }

    lazy var username = UITextField()
    lazy var password = UITextField()
    lazy var loginButton = UIButton()
    lazy var registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = R.string.localizable.login_screen_title()

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
        loginButton.setTitle(R.string.localizable.login_button_title_login(), for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(password.snp_bottom).offset(16)
        }

        view.addSubview(registerButton)
        registerButton.backgroundColor = Style.buttonBackgroundColor
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
        self.navigationController?.pushViewController(SelectRoleViewController(), animated: true)
    }

    @objc func registerButtonPressed(sender: UIButton!) {
        self.navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
}
