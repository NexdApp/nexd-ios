//
//  PhoneCallViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 10.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxCocoa
import RxSwift

class PhoneCallViewController: ViewController<PhoneCallViewController.ViewModel> {
    static let phoneNumber = "0721-98419016‌"

    class ViewModel {
        private let callsService: CallsService

        private lazy var phoneNumber = callsService.number()
        private let placeholder = R.string.localizable.seeker_phone_call_text_ios("???").asHeading()

        var text: Driver<NSAttributedString?> {
            phoneNumber.map { number in
                let formatted = R.string.localizable.seeker_phone_call_text_ios(number)
                return formatted.asLinkedHeading(range: formatted.range(of: number), target: "tel://\(number)")
            }
            .asObservable()
            .startWith(placeholder)
            .asDriver(onErrorJustReturn: placeholder)
        }

        init(callsService: CallsService) {
            self.callsService = callsService
        }
    }

    private let content = UIView()
    private let text = UILabel()
    private let backButton = UIButton()

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
        text.numberOfLines = 0
        text.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    override func bind(viewModel: PhoneCallViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.text.drive(text.rx.attributedText)
        )
    }
}
