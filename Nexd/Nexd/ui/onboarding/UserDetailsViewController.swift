//
//  UserDetailsViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import NexdClient
import RxSwift
import SnapKit
import UIKit
import Validator

class UserDetailsViewController: ViewController<UserDetailsViewController.ViewModel> {
    struct ViewModel {
        let navigator: Navigator
        var userInformation: UserInformation
    }

    struct UserInformation {
        let firstName: String
        let lastName: String
    }

    private let disposeBag = DisposeBag()
    private var keyboardObserver: KeyboardObserver?
    private var keyboardDismisser: KeyboardDismisser?

    lazy var scrollView = UIScrollView()

    lazy var logo = UIImageView()

    lazy var phone = ValidatingTextField.make(tag: 0,
                                              placeholder: R.string.localizable.registration_placeholder_phone(),
                                              icon: R.image.hashtag(),
                                              keyboardType: .phonePad,
                                              validationRules: .phone)

    lazy var zipCode = ValidatingTextField.make(tag: 1,
                                                placeholder: R.string.localizable.registration_placeholder_zip(),
                                                icon: R.image.hashtag(),
                                                keyboardType: .phonePad,
                                                validationRules: .zipCode)

    lazy var registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardDismisser = KeyboardDismisser(rootView: view)

        view.backgroundColor = .white
        title = R.string.localizable.registration_screen_title()

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

        contentView.addSubview(logo)
        logo.image = R.image.logo()
        logo.snp.makeConstraints { make -> Void in
            make.size.equalTo(Style.logoSize)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(68)
        }

        contentView.addSubview(phone)
        phone.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(logo.snp.bottom).offset(134)
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
            make.top.equalTo(zipCode.snp_bottom).offset(180)
            make.bottom.equalToSuperview().offset(-20)
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

    override func bind(viewModel: UserDetailsViewController.ViewModel, disposeBag: DisposeBag) { }

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
        UserService.shared.updateUserInformation(zipCode: zipCode, phone: phone)
            .subscribe(onSuccess: { [weak self] user in
                log.debug("User information updated: \(user)")
                self?.viewModel?.navigator.toMainScreen()
            }, onError: { [weak self] error in
                log.error("UserInformation update failed: \(error)")
                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
            })
            .disposed(by: disposeBag)
    }
}
