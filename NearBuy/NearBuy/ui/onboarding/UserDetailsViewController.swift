//
//  UserDetailsViewController.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import OpenAPIClient
import UIKit

class UserDetailsViewController: UIViewController {
    enum Style {
        static let buttonBackgroundColor: UIColor = .gray
        static let textFieldHeight: CGFloat = 36
        static let buttonHeight: CGFloat = 52
    }

    struct UserInformation {
        let userId: Int
        let firstName: String
        let lastName: String
    }

    var userInformation: UserInformation!

    private let disposeBag = DisposeBag()

    lazy var gradient = GradientView()

    lazy var phone = TextField()
    lazy var zipCode = TextField()

    lazy var registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = R.string.localizable.registration_screen_title()

        view.addSubview(gradient)
        gradient.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(phone)
        phone.keyboardType = .phonePad
        phone.styled(placeholder: R.string.localizable.registration_placeholer_phone())
        phone.snp.makeConstraints { make -> Void in
            make.height.equalTo(Style.textFieldHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.topMargin.equalTo(50)
        }

        view.addSubview(zipCode)
        zipCode.keyboardType = .phonePad
        zipCode.styled(placeholder: R.string.localizable.registration_placeholer_zip())
        zipCode.snp.makeConstraints { make -> Void in
            make.height.equalTo(Style.textFieldHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(phone.snp_bottom).offset(16)
        }

        view.addSubview(registerButton)
        registerButton.style(text: R.string.localizable.registration_button_title_send())
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(zipCode.snp_bottom).offset(16)
        }
    }
}

extension UserDetailsViewController {
    @objc func registerButtonPressed(sender: UIButton!) {
        log.debug("Send registration to backend")

        guard let zipCode = zipCode.text, let phone = phone.text else {
            log.warning("Cannot update user, mandatory field is missing!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        UserService.shared.updateUserInformation(id: userInformation.userId,
                                                 zipCode: zipCode,
                                                 firstName: userInformation.firstName,
                                                 lastName: userInformation.lastName,
                                                 phone: phone)
            .subscribe(onSuccess: { [weak self] user in
                log.debug("User information updated: \(user)")
                self?.navigationController?.pushViewController(SelectRoleViewController(), animated: true)
            }) { [weak self] error in
                log.error("UserInformation update failed: \(error)")
                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
            }
            .disposed(by: disposeBag)
    }
}
