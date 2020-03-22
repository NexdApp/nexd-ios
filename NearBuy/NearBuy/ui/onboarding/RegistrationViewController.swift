//
//  ViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SnapKit
import UIKit
import RxSwift
import SwaggerClient

class RegistrationViewController: UIViewController {
    enum Style {
        static let buttonBackgroundColor: UIColor = .gray
    }

    struct Result {
        let email: String
        let password: String
    }

    private let disposeBag = DisposeBag()

    lazy var gradient = GradientView()
    lazy var email = UITextField()
    lazy var firstName = UITextField()
    lazy var lastName = UITextField()
    lazy var phone = UITextField()
    lazy var password = UITextField()
    lazy var confirmPassword = UITextField()

    lazy var registerButton = UIButton()

    var onRegistrationFinished: ((Result) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = R.string.localizable.registration_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(email)
        email.placeholder = R.string.localizable.registration_placeholer_email()
        email.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.topMargin.equalTo(50)
        }

        view.addSubview(firstName)
        firstName.placeholder = R.string.localizable.registration_placeholer_firstname()
        firstName.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(email.snp_bottom).offset(16)
        }

        view.addSubview(lastName)
        lastName.placeholder = R.string.localizable.registration_placeholer_lastname()
        lastName.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(firstName.snp_bottom).offset(16)
        }

        view.addSubview(phone)
        phone.placeholder = R.string.localizable.registration_placeholer_phone()
        phone.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(lastName.snp_bottom).offset(16)
        }

        view.addSubview(password)
        password.placeholder = R.string.localizable.registration_placeholer_password()
        password.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(phone.snp_bottom).offset(16)
        }

        view.addSubview(confirmPassword)
        confirmPassword.placeholder = R.string.localizable.registration_placeholer_confirm_password()
        confirmPassword.snp.makeConstraints { make -> Void in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(password.snp_bottom).offset(16)
        }

        view.addSubview(registerButton)
        registerButton.backgroundColor = Style.buttonBackgroundColor
        registerButton.setTitle(R.string.localizable.registration_button_title_send(), for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.leftMargin.rightMargin.equalTo(8)
            make.top.equalTo(password.snp_bottom).offset(16)
        }
    }
}

extension RegistrationViewController {
    @objc func registerButtonPressed(sender: UIButton!) {
        log.debug("Send registration to backend")

        guard let email = email.text, let firstName = firstName.text, let lastName = lastName.text, let password = password.text else {
            log.warning("Cannot register user, mandatory field is missing!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        AuthenticationService.shared.register(email: email,
                                              firstName: firstName,
                                              lastName: lastName,
                                              password: password)
            .subscribe(onSuccess: { [weak self] response in
                log.debug("User registration successful")

                if let token = Storage.shared.authorizationToken {
                    SwaggerClientAPI.customHeaders = ["Authorization": "Bearer \(token)"]
                }

                Storage.shared.authorizationToken = response.accessToken
                Storage.shared.userId = response._id

                self?.navigationController?.pushViewController(SelectRoleViewController(), animated: true)
            }, onError: { [weak self] error in
                log.error("User registration failed: \(error)")

                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
            })
            .disposed(by: disposeBag)
    }
}
