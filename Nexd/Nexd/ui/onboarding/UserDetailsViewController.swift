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
import Validator

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

    lazy var phone = ValidatingTextField.make(tag: 0,
                                              placeholder: R.string.localizable.registration_placeholer_phone(),
                                              keyboardType: .phonePad,
                                              validationRules: .phone())

    lazy var zipCode = ValidatingTextField.make(tag: 0,
                                                placeholder: R.string.localizable.registration_placeholer_zip(),
                                                keyboardType: .phonePad,
                                                validationRules: .zipCode())

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
        phone.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.topMargin.equalTo(50)
        }

        contentView.addSubview(zipCode)
        zipCode.snp.makeConstraints { make -> Void in
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
        let hasInvalidInput = [phone, zipCode]
            .map { $0.validate() }
            .contains(false)

        guard !hasInvalidInput else {
            log.warning("Cannot update user, mandatory field is missing!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        guard let zipCode = zipCode.value, let phone = phone.value else {
            log.warning("Cannot update user, mandatory field is missing!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        log.debug("Send registration to backend")
        UserService.shared.updateUserInformation(usreId: userInformation.userId,
                                                 zipCode: zipCode,
                                                 firstName: userInformation.firstName,
                                                 lastName: userInformation.lastName,
                                                 phone: phone)
            .subscribe(onSuccess: { [weak self] user in
                log.debug("User information updated: \(user)")
                self?.navigationController?.setViewControllers([SelectRoleViewController()], animated: true)
            }, onError: { [weak self] error in
                log.error("UserInformation update failed: \(error)")
                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
            })
            .disposed(by: disposeBag)
    }
}

private extension ValidationRuleSet where InputType == String {
    enum ValidationErrors: String, ValidationError {
        case phoneNumberInvalid = "Phone number is invalid"
        case zipCodeInvalid = "ZIP code is invalid"
        var message: String { return rawValue }
    }

    static func phone() -> ValidationRuleSet<String> {
        ValidationRuleSet(rules: [ValidationRuleLength(min: 3, error: ValidationErrors.phoneNumberInvalid)])
    }

    static func zipCode() -> ValidationRuleSet<String> {
        ValidationRuleSet<String>(rules: [ValidationRulePattern(pattern: "^[0-9]+$", error: ValidationErrors.zipCodeInvalid)])
    }
}
