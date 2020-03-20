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
    lazy var username = UITextField()
    lazy var password = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(username)
        view.addSubview(password)

        username.placeholder = "Username"
        username.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.centerY.equalTo(self.view)
        }

        password.placeholder = "Password"
        password.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(username.snp_bottom).offset(16)
        }
    }
}
