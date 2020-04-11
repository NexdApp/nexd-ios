//
//  PhoneCallViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxCocoa
import RxSwift

enum PhoneCallError: Error {
    case phoneNumberUnknown
}
class PhoneCallViewController: ViewController<PhoneCallViewController.ViewModel> {
    class ViewModel {
        private let callsService: CallsService
        private let navigator: ScreenNavigating

        private lazy var phoneNumber = callsService.number()
        private let placeholder = R.string.localizable.seeker_phone_call_text_ios("???").asHeading()

        var text: Driver<NSAttributedString?> {
            phoneNumber.map { number in
                guard let number = number?.number else { throw PhoneCallError.phoneNumberUnknown }
                return R.string.localizable.seeker_phone_call_text_ios(number).asHeading()
            }
            .asObservable()
            .startWith(placeholder)
            .asDriver(onErrorJustReturn: placeholder)
        }

        let backButtonTitle = Driver.just(R.string.localizable.back_button_title().asNegativeButtonText())

        var backButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.goBack()
            }
        }

        init(callsService: CallsService, navigator: ScreenNavigating) {
            self.callsService = callsService
            self.navigator = navigator
        }
    }

    private let content = UIView()
    private let text = UITextView()
    private let backButton = BackButton.make()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.nexdGreen()

        view.addSubview(content)
        content.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        content.addSubview(text)
        text.isScrollEnabled = false
        text.isEditable = false
        text.backgroundColor = .clear
        text.linkTextAttributes = [ .foregroundColor: R.color.darkButtonText()! ]
        text.dataDetectorTypes = .phoneNumber
        text.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        content.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(text.snp.bottom).offset(44)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.bottom.equalToSuperview()
        }
    }

    override func bind(viewModel: PhoneCallViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.text.drive(text.rx.attributedText),
            viewModel.backButtonTitle.drive(backButton.rx.attributedTitle(for: .normal)),
            backButton.rx.tap.bind(to: viewModel.backButtonTaps)
        )
    }
}
