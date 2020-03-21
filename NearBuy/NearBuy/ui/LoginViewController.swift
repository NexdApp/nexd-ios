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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = R.string.localizable.login_SCREEN_TITLE()

        view.addSubview(username)
        username.placeholder = R.string.localizable.login_PLACEHOLDER_USERNAME()

        username.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.topMargin.equalTo(50)
        }

        view.addSubview(password)
        password.placeholder = R.string.localizable.login_PLACEHOLDER_PASSWORD()
        password.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(username.snp_bottom).offset(16)
        }

        view.addSubview(loginButton)
        loginButton.backgroundColor = Style.buttonBackgroundColor
        loginButton.setTitle(R.string.localizable.login_BUTTON_TITLE_LOGIN(), for: .normal)
        loginButton.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(password.snp_bottom).offset(16)
        }
    }
}

extension LoginViewController {
    @objc func pressed(sender: UIButton!) {
        log.debug("Hello World")

        self.navigationController?.pushViewController(SelectRoleViewController(), animated: true)
    }
}
