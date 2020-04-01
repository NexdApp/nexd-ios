//
//  UserDetailsViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import RxSwift
import SnapKit
import UIKit

class UserDetailsViewController: UIViewController {
    struct UserInformation {
        let userId: Int
        let firstName: String
        let lastName: String
    }

    var userInformation: UserInformation!

    private let disposeBag = DisposeBag()
    private var keyboardObserver: KeyboardObserver?
    private var keyboardDismisser: KeyboardDismisser?

    lazy var gradient = GradientView()
    lazy var scrollView = UIScrollView()

    lazy var phone = TextField()
    lazy var zipCode = TextField()

    lazy var registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardDismisser = KeyboardDismisser(rootView: view)

        view.backgroundColor = .white
        title = R.string.localizable.registration_screen_title()

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

        contentView.addSubview(phone)
        phone.keyboardType = .phonePad
        phone.styled(placeholder: R.string.localizable.registration_placeholer_phone())
        phone.snp.makeConstraints { make -> Void in
            make.height.equalTo(Style.textFieldHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.topMargin.equalTo(50)
        }

        contentView.addSubview(zipCode)
        zipCode.keyboardType = .phonePad
        zipCode.styled(placeholder: R.string.localizable.registration_placeholer_zip())
        zipCode.snp.makeConstraints { make -> Void in
            make.height.equalTo(Style.textFieldHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(phone.snp_bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(registerButton)
        registerButton.style(text: R.string.localizable.registration_button_title_send())
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(zipCode.snp_bottom).offset(Style.verticalPadding)
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

extension UserDetailsViewController {
    @objc func registerButtonPressed(sender: UIButton!) {
        log.debug("Send registration to backend")

        guard let zipCode = zipCode.text, let phone = phone.text else {
            log.warning("Cannot update user, mandatory field is missing!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        UserService.shared.updateUserInformation(usreId: userInformation.userId,
                                                 zipCode: zipCode,
                                                 firstName: userInformation.firstName,
                                                 lastName: userInformation.lastName,
                                                 phone: phone)
            .subscribe(onSuccess: { [weak self] user in
                log.debug("User information updated: \(user)")
                self?.navigationController?.pushViewController(SelectRoleViewController(), animated: true)
            }, onError: { [weak self] error in
                log.error("UserInformation update failed: \(error)")
                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
            })
            .disposed(by: disposeBag)
    }
}
