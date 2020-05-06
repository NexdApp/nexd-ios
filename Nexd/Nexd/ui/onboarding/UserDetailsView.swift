//
//  UserDetailsViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

//import Cleanse
//import NexdClient
//import RxSwift
//import SnapKit
//import UIKit
//import Validator

import Combine
import SwiftUI

struct UserDetailsView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return Text("Hello World")
    }
}

extension UserDetailsView {
        struct UserInformation {
            let firstName: String
            let lastName: String
        }

    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var email: String?
            @Published var firstname: String?
            @Published var lastname: String?
            @Published var password: String?
            @Published var confirmPassword: String?
            @Published var isPrivacyPolicyAccepted: Bool = false
            @Published var dialog: Dialog?
        }

        private let navigator: ScreenNavigating
        private let userInformation: UserInformation
        private var cancellableSet: Set<AnyCancellable>?

        var state = ViewState()

        init(navigator: ScreenNavigating, userInformation: UserInformation) {
            self.navigator = navigator
            self.userInformation = userInformation
        }

        func continueButtonTapped() {
            guard state.isPrivacyPolicyAccepted else {
                log.warning("Cannot regitster user! Did not agree to Privacy Policy")
                state.dialog = Dialog(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_did_not_consent_privacy_policy())
                return
            }

            guard let email = state.email,
                let firstName = state.firstname,
                let lastName = state.lastname,
                let password = state.password,
                let confirmPassword = state.confirmPassword else {
                log.warning("Cannot register user, mandatory field is missing!")
                state.dialog = Dialog(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
                return
            }

            guard email.validate(rules: .email).isValid,
                firstName.validate(rules: .firstName).isValid,
                lastName.validate(rules: .lastName).isValid,
                password.validate(rules: .password).isValid,
                confirmPassword.validate(rules: .passwordConfirmation { password }).isValid else {
                log.warning("Cannot register user! Validation failed!")
                state.dialog = Dialog(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
                return
            }

            log.debug("Send registration to backend")
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            state.objectWillChange
                .sink { [weak self] in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellableSet)

            self.cancellableSet = cancellableSet
        }

        func unbind() {
            cancellableSet = nil
        }
    }

    static func createScreen(viewModel: UserDetailsView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: UserDetailsView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.defaultBackground()
        return screen
    }
}

// class UserDetailsViewController: ViewController<UserDetailsViewController.ViewModel> {
//    struct ViewModel {
//        let navigator: Navigator
//        var userInformation: UserInformation
//    }
//
//    struct UserInformation {
//        let firstName: String
//        let lastName: String
//    }
//
//    private let disposeBag = DisposeBag()
//    private var keyboardObserver: KeyboardObserver?
//    private var keyboardDismisser: KeyboardDismisser?
//
//    lazy var scrollView = UIScrollView()
//
//    lazy var logo = UIImageView()
//
//    lazy var phone = ValidatingTextField.make(tag: 0,
//                                              placeholder: R.string.localizable.registration_placeholder_phone(),
//                                              icon: R.image.hashtag(),
//                                              keyboardType: .phonePad,
//                                              validationRules: .phone)
//
//    lazy var zipCode = ValidatingTextField.make(tag: 1,
//                                                placeholder: R.string.localizable.registration_placeholder_zip(),
//                                                icon: R.image.hashtag(),
//                                                keyboardType: .phonePad,
//                                                validationRules: .zipCode)
//
//    lazy var registerButton = MenuButton.make(style: .solid)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        keyboardDismisser = KeyboardDismisser(rootView: view)
//
//        view.backgroundColor = .white
//        title = R.string.localizable.registration_screen_title()
//
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        let contentView = UIView()
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.left.right.equalTo(view)
//        }
//
//        contentView.addSubview(logo)
//        logo.image = R.image.logo()
//        logo.snp.makeConstraints { make -> Void in
//            make.size.equalTo(Style.logoSize)
//            make.centerX.equalToSuperview()
//            make.topMargin.equalTo(68)
//        }
//
//        contentView.addSubview(phone)
//        phone.snp.makeConstraints { make -> Void in
//            make.leftMargin.equalTo(8)
//            make.rightMargin.equalTo(-8)
//            make.top.equalTo(logo.snp.bottom).offset(134)
//        }
//
//        contentView.addSubview(zipCode)
//        zipCode.snp.makeConstraints { make -> Void in
//            make.leftMargin.equalTo(8)
//            make.rightMargin.equalTo(-8)
//            make.top.equalTo(phone.snp_bottom).offset(Style.verticalPadding)
//        }
//
//        contentView.addSubview(registerButton)
//        registerButton.setAttributedTitle(R.string.localizable.registration_button_title_send().asSolidButtonText(), for: .normal)
//        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
//        registerButton.snp.makeConstraints { make in
//            make.height.equalTo(Style.buttonHeight)
//            make.leftMargin.equalTo(8)
//            make.rightMargin.equalTo(-8)
//            make.top.greaterThanOrEqualTo(zipCode.snp.bottom).offset(80)
//            make.bottom.equalToSuperview().offset(-20)
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        keyboardObserver = KeyboardObserver.insetting(scrollView: scrollView)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        keyboardObserver = nil
//    }
//
//    override func bind(viewModel: UserDetailsViewController.ViewModel, disposeBag: DisposeBag) { }
//
// }
// extension UserDetailsViewController {
//    @objc func registerButtonPressed(sender: UIButton!) {
//        let hasInvalidInput = [phone, zipCode]
//            .map { $0.validate() }
//            .contains(false)
//
//        guard !hasInvalidInput else {
//            log.warning("Cannot update user, mandatory field is missing!")
//            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
//            return
//        }
//
//        guard let zipCode = zipCode.value, let phone = phone.value else {
//            log.warning("Cannot update user, mandatory field is missing!")
//            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
//            return
//        }
//
//        log.debug("Send registration to backend")
//        UserService.shared.updateUserInformation(zipCode: zipCode, phone: phone)
//            .subscribe(onSuccess: { [weak self] user in
//                log.debug("User information updated: \(user)")
//                self?.viewModel?.navigator.toMainScreen()
//            }, onError: { [weak self] error in
//                log.error("UserInformation update failed: \(error)")
//                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
//            })
//            .disposed(by: disposeBag)
//    }
// }
