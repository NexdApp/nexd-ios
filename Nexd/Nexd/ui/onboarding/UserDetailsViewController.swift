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

    private let caShapeLayer = CAShapeLayer()

    lazy var scrollView = UIScrollView()

    lazy var logo = UIImageView()

    lazy var phone = ValidatingTextField.make(tag: 0,
                                              placeholder: R.string.localizable.registration_placeholder_phone(),
                                              keyboardType: .phonePad,
                                              validationRules: .phone())

    lazy var zipCode = ValidatingTextField.make(tag: 0,
                                                placeholder: R.string.localizable.registration_placeholder_zip(),
                                                keyboardType: .phonePad,
                                                validationRules: .zipCode())

    lazy var registerButton = UIButton()

    lazy var privacyPolicy = UITextView()

    lazy var phoneNumberImageView = UIImageView()

    lazy var postalCodeImageView = UIImageView()

    lazy var confirmTermsOfUseButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageViews()
        confirmTermsOfUseButton.addTarget(self, action: #selector(confirmTermsOfUseButtonPressed), for: .touchUpInside)

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

        contentView.addSubview(phoneNumberImageView)
        phoneNumberImageView.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(phone.snp_centerY).offset(-7.5)
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.right.equalToSuperview().offset(-41)
        }

        contentView.addSubview(zipCode)
        zipCode.snp.makeConstraints { make -> Void in
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(phone.snp_bottom).offset(Style.verticalPadding)
        }

        contentView.addSubview(postalCodeImageView)
        postalCodeImageView.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(zipCode.snp_centerY).offset(-7.5)
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.right.equalToSuperview().offset(-41)
        }

        contentView.addSubview(privacyPolicy)
        privacyPolicy.backgroundColor = .clear
        privacyPolicy.isScrollEnabled = false
        privacyPolicy.textContainerInset = .zero

        let term = R.string.localizable.registration_term_privacy_policy()
        let formatted = R.string.localizable.registration_label_privacy_policy_agreement(term)
        privacyPolicy.attributedText = formatted.asLink(range: formatted.range(of: term), target: "https://www.nexd.app/privacypage")
        privacyPolicy.snp.makeConstraints { make -> Void in
            make.height.equalTo(54)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(zipCode.snp.bottom).offset(50)
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
        registerButton.style(text: R.string.localizable.registration_button_title_send())
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Style.buttonHeight)
            make.leftMargin.equalTo(8)
            make.rightMargin.equalTo(-8)
            make.top.equalTo(privacyPolicy.snp_bottom).offset(150)
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

    override func viewDidLayoutSubviews() {
        drawCircle(on: confirmTermsOfUseButton)
    }

    override func bind(viewModel: UserDetailsViewController.ViewModel, disposeBag: DisposeBag) { }

    private func setupImageViews() {
        phoneNumberImageView.image = R.image.hashtag()
        phoneNumberImageView.contentMode = .scaleAspectFit

        postalCodeImageView.image = R.image.hashtag()
        postalCodeImageView.contentMode = .scaleAspectFit
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

extension UserDetailsViewController {
    @objc func confirmTermsOfUseButtonPressed() {
        if caShapeLayer.fillColor == UIColor.clear.cgColor {
            caShapeLayer.fillColor = R.color.nexdGreen()?.cgColor
        } else {
            caShapeLayer.fillColor = UIColor.clear.cgColor
        }
    }

    @objc func registerButtonPressed(sender: UIButton!) {
        let hasInvalidInput = [phone, zipCode]
            .map { $0.validate() }
            .contains(false)

        guard let userInformation = viewModel?.userInformation else {
            log.warning("Cannot update user, internal error!")
            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
            return
        }

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
        UserService.shared.updateUserInformation(zipCode: zipCode,
                                                 firstName: userInformation.firstName,
                                                 lastName: userInformation.lastName,
                                                 phone: phone)
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
