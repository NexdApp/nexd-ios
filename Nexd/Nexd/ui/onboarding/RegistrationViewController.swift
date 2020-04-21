//
//  ViewController.swift
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

class RegistrationViewController: ViewController<RegistrationViewController.ViewModel> {
    struct ViewModel {
        let navigator: ScreenNavigating
    }
    
    private var didAgreeTermsOfUse: Bool = false

    private let disposeBag = DisposeBag()
    private var keyboardObserver: KeyboardObserver?
    private var keyboardDismisser: KeyboardDismisser?
    
    private let caShapeLayer = CAShapeLayer()
    
    lazy var logo = UIImageView()

    lazy var scrollView = UIScrollView()

    lazy var email = ValidatingTextField.make(tag: 0,
                                              placeholder: R.string.localizable.registration_placeholder_email(),
                                              icon: R.image.mail1(),
                                              keyboardType: .emailAddress,
                                              autoCapitalizationType: .none,
                                              validationRules: .email)

    lazy var firstName = ValidatingTextField.make(tag: 1,
                                                  placeholder: R.string.localizable.registration_placeholder_firstName(),
                                                  icon: R.image.person1(),
                                                  validationRules: .firstName)

    lazy var lastName = ValidatingTextField.make(tag: 2,
                                                 placeholder: R.string.localizable.registration_placeholder_lastName(),
                                                 icon: R.image.person1(),
                                                 validationRules: .lastName)

    lazy var password = ValidatingTextField.make(tag: 3,
                                                 placeholder: R.string.localizable.registration_placeholder_password(),
                                                 icon: R.image.lock2(),
                                                 isSecureTextEntry: true,
                                                 validationRules: .password)

    lazy var confirmPassword = ValidatingTextField.make(tag: 4,
                                                        placeholder: R.string.localizable.registration_placeholder_confirm_password(),
                                                        icon: R.image.lock1(),
                                                        isSecureTextEntry: true,
                                                        validationRules: .passwordConfirmation { [weak self] in self?.password.value ?? "" })

    lazy var registerButton = UIButton()
    
    lazy var privacyPolicy = UITextView()
    
    lazy var confirmTermsOfUseButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        didAgreeTermsOfUse = false
        confirmTermsOfUseButton.addTarget(self, action: #selector(confirmTermsOfUseButtonPressed), for: .touchUpInside)

        keyboardDismisser = KeyboardDismisser(rootView: view)

        view.backgroundColor = .white
        title = R.string.localizable.registration_screen_title()

        setupLayoutConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver = KeyboardObserver.insetting(scrollView: scrollView)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardObserver = nil
    }
    
    override func viewDidLayoutSubviews() {
        drawCircle(on: confirmTermsOfUseButton)
    }

    override func bind(viewModel: RegistrationViewController.ViewModel, disposeBag: DisposeBag) {}

    private func setupLayoutConstraints() {
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

        contentView.addSubview(email)
        email.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(logo.snp.bottom).offset(114)
        }

        contentView.addSubview(firstName)
        firstName.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(email.snp.bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(lastName)
        lastName.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(firstName.snp.bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(password)
        password.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(lastName.snp.bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(confirmPassword)
        confirmPassword.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(password.snp.bottom).offset(Style.verticalPadding)
        }
        
        contentView.addSubview(privacyPolicy)
        privacyPolicy.backgroundColor = .clear
        privacyPolicy.isScrollEnabled = false
        privacyPolicy.textContainerInset = .zero
        
        let term = R.string.localizable.registration_term_privacy_policy()
        let formatted = R.string.localizable.registration_label_privacy_policy_agreement(term)
        privacyPolicy.attributedText = formatted.asLink(range: formatted.range(of: term), target: "https://www.nexd.app/privacy")
        privacyPolicy.snp.makeConstraints { make -> Void in
            make.height.equalTo(54)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(confirmPassword.snp.bottom).offset(12)
        }
        
        contentView.addSubview(confirmTermsOfUseButton)
        confirmTermsOfUseButton.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(privacyPolicy.snp_centerY).offset(-7.5)
            make.left.equalToSuperview().offset(27)
            make.right.equalTo(privacyPolicy.snp.left).offset(-9)
            make.height.equalTo(26)
            make.width.equalTo(26)
        }

        contentView.addSubview(registerButton)
        registerButton.style(text: R.string.localizable.registration_button_title_continue())
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(confirmPassword.snp.bottom).offset(80)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func drawCircle(on button: UIButton) {
        let buttonWidth = button.frame.size.width
        let buttonHeight = button.frame.size.height

        let centerCoordinates = CGPoint(x: buttonWidth / 2, y: buttonHeight / 2)

        let smallestAspect = min(button.frame.width, button.frame.height)
        let circleRadiusWithinButton = smallestAspect / 2

        // prevents setting the layer when the constraints have not been set properly yet
        if buttonWidth != 0, buttonHeight != 0, circleRadiusWithinButton != 0 {
            let circularPath = UIBezierPath(arcCenter: centerCoordinates,
                                            radius: circleRadiusWithinButton,
                                            startAngle: 0,
                                            endAngle: 2 * CGFloat.pi,
                                            clockwise: true)
            caShapeLayer.path = circularPath.cgPath
            caShapeLayer.strokeColor = R.color.nexdGreen()?.cgColor
            caShapeLayer.lineWidth = 3.0
            caShapeLayer.fillColor  = UIColor.clear.cgColor
            button.layer.addSublayer(caShapeLayer)
        }
    }
}

extension RegistrationViewController {
    @objc func confirmTermsOfUseButtonPressed() {
        if caShapeLayer.fillColor == UIColor.clear.cgColor {
            caShapeLayer.fillColor = R.color.nexdGreen()?.cgColor
        } else {
            caShapeLayer.fillColor = UIColor.clear.cgColor
        }
        didAgreeTermsOfUse = !didAgreeTermsOfUse
    }
    
    @objc func registerButtonPressed(sender: UIButton!) {
        let hasInvalidInput = [email, firstName, lastName, password, confirmPassword]
            .map { $0.validate() }
            .contains(false)
        
        guard didAgreeTermsOfUse else {
            log.warning("Cannot regitster user! Did not agree to Privacy Policy")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_field_missing())
            return
        }

        guard !hasInvalidInput else {
            log.warning("Cannot register user! Validation failed!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        guard let email = email.value, let firstName = firstName.value, let lastName = lastName.value, let password = password.value else {
            log.warning("Cannot register user, mandatory field is missing!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

        log.debug("Send registration to backend")
        AuthenticationService.shared.register(email: email,
                                              firstName: firstName,
                                              lastName: lastName,
                                              password: password)
            .subscribe(onCompleted: { [weak self] in
                log.debug("User registration successful")
                let userInformation = UserDetailsViewController.UserInformation(firstName: firstName, lastName: lastName)
                self?.viewModel?.navigator.toUserDetailsScreen(with: userInformation)
            }, onError: { [weak self] error in
                log.error("User registration failed: \(error)")

                if let errorResponse = error as? ErrorResponse, errorResponse.httpStatusCode == .conflict {
                    log.debug("User already exists")
                    self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_user_already_exists())
                }

                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
            })
            .disposed(by: disposeBag)
    }
}
