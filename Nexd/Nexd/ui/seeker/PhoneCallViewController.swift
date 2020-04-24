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
        private let phoneService: PhoneService
        private let navigator: ScreenNavigating

        private lazy var phoneNumber = phoneService.numbers()
        private let placeholder = R.string.localizable.seeker_phone_call_text_ios("???").asHeading()

        var text: Driver<NSAttributedString?> {
            phoneNumber.map { numbers in
                let dto = numbers.filter { dto -> Bool in dto.country == Locale.current.regionCode }.first ?? numbers.first

                guard let number = dto?.number else { throw PhoneCallError.phoneNumberUnknown }
                return R.string.localizable.seeker_phone_call_text_ios(number).asHeading()
            }
            .asObservable()
            .startWith(placeholder)
            .asDriver(onErrorJustReturn: placeholder)
        }

        let backButtonTitle = Driver.just(R.string.localizable.back_button_title().asBackButtonText())

        var backButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.goBack()
            }
        }

        init(phoneService: PhoneService, navigator: ScreenNavigating) {
            self.phoneService = phoneService
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
            make.center.equalTo(view)
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
            make.centerY.centerX.equalToSuperview()
        }

        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view).offset(25)
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.height.equalTo(132)
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
