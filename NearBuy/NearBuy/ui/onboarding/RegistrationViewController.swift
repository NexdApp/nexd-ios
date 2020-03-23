//
//  ViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import OpenAPIClient
import UIKit

class RegistrationViewController: UIViewController {
    enum Style {
        static let buttonBackgroundColor: UIColor = .gray
        static let textFieldHeight: CGFloat = 36
        static let buttonHeight: CGFloat = 52
    }

    private let disposeBag = DisposeBag()

    lazy var gradient = GradientView()

    lazy var email = TextField()
    lazy var firstName = TextField()
    lazy var lastName = TextField()
    lazy var password = TextField()
    lazy var confirmPassword = TextField()

    lazy var registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = R.string.localizable.registration_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(email)
        email.keyboardType = .emailAddress
        email.styled(placeholder: R.string.localizable.registration_placeholer_email())
        email.snp.makeConstraints { make -> Void in
            make.height.equalTo(Style.textFieldHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.topMargin.equalTo(50)
        }

        view.addSubview(firstName)
        firstName.styled(placeholder: R.string.localizable.registration_placeholer_firstname())
        firstName.snp.makeConstraints { make -> Void in
            make.height.equalTo(Style.textFieldHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(email.snp_bottom).offset(16)
        }

        view.addSubview(lastName)
        lastName.styled(placeholder: R.string.localizable.registration_placeholer_lastname())
        lastName.snp.makeConstraints { make -> Void in
            make.height.equalTo(Style.textFieldHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(firstName.snp_bottom).offset(16)
        }

        view.addSubview(password)
        password.styled(placeholder: R.string.localizable.registration_placeholer_password())
        password.isSecureTextEntry = true
        password.snp.makeConstraints { make -> Void in
            make.height.equalTo(Style.textFieldHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(lastName.snp_bottom).offset(16)
        }

        view.addSubview(confirmPassword)
        confirmPassword.styled(placeholder: R.string.localizable.registration_placeholer_confirm_password())
        confirmPassword.isSecureTextEntry = true
        confirmPassword.snp.makeConstraints { make -> Void in
            make.height.equalTo(Style.textFieldHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(password.snp_bottom).offset(16)
        }

        view.addSubview(registerButton)
        registerButton.style(text: R.string.localizable.registration_button_title_continue())
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(confirmPassword.snp_bottom).offset(16)
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

                OpenAPIClientAPI.customHeaders = ["Authorization": "Bearer \(response.accessToken)"]

                Storage.shared.authorizationToken = response.accessToken
                Storage.shared.userId = response.id

                let userDetailsVC = UserDetailsViewController()
                userDetailsVC.userInformation = UserDetailsViewController.UserInformation(userId: response.id, firstName: firstName, lastName: lastName)
                self?.navigationController?.pushViewController(userDetailsVC, animated: true)
            }, onError: { [weak self] error in
                log.error("User registration failed: \(error)")

                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
            })
            .disposed(by: disposeBag)
    }
}
