//
//  RequestConfirmationViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 11.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class RequestConfirmationViewController: ViewController<RequestConfirmationViewController.ViewModel> {
    struct Item {
        let itemId: Int64
        let title: String
        let amount: Int64
    }

    class ViewModel {
        let navigator: ScreenNavigating
        let items: [Item]

        let titleText = Driver.just(R.string.localizable.seeker_detail_screen_title().asHeading())

        init(navigator: ScreenNavigating, items: [Item]) {
            self.navigator = navigator
            self.items = items
        }
    }

    private var keyboardObserver: KeyboardObserver?
    private var keyboardDismisser: KeyboardDismisser?

    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let street = TextField()
    private let number = TextField()
    private let zipCode = TextField()
    private let city = TextField()
    private let phoneNumber = TextField()
    private let additionalRequest = TextField()
    private let deliveryComment = TextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardDismisser = KeyboardDismisser(rootView: view)

        view.backgroundColor = R.color.nexdGreen()
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.left.equalTo(view).offset(34)
            make.right.equalTo(view).offset(-36)
        }

        stackView.asCard()
        stackView.alignment = .center
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(23)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-12)
        }

        guard let items = viewModel?.items else { return }
        for item in items {
            let itemView = RequestConfirmationItemView()
            itemView.title.attributedText = "\(item.title)".asListItemTitle()
            itemView.amount.attributedText = "\(item.amount)x".asListItemDetails()

            stackView.addArrangedSubview(itemView)

            itemView.snp.makeConstraints { make in
                make.left.equalTo(view).offset(13)
                make.right.equalTo(view).offset(-12)
                make.height.equalTo(52)
            }
        }

        scrollView.addSubview(street)
        street.withBottomBorder()
        street.placeholder = R.string.localizable.user_input_details_placeholder_street()
        street.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(23)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-12)
        }

        scrollView.addSubview(number)
        number.withBottomBorder()
        number.placeholder = R.string.localizable.user_input_details_placeholder_houseNumber()
        number.snp.makeConstraints { make in
            make.top.equalTo(street.snp.bottom).offset(23)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-12)
        }

        scrollView.addSubview(zipCode)
        zipCode.withBottomBorder()
        zipCode.placeholder = R.string.localizable.user_input_details_placeholder_zipCode()
        zipCode.snp.makeConstraints { make in
            make.top.equalTo(number.snp.bottom).offset(23)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-12)
        }

        scrollView.addSubview(city)
        city.withBottomBorder()
        city.placeholder = R.string.localizable.user_input_details_placeholder_city()
        city.snp.makeConstraints { make in
            make.top.equalTo(zipCode.snp.bottom).offset(23)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-12)
        }

        scrollView.addSubview(phoneNumber)
        phoneNumber.withBottomBorder()
        phoneNumber.placeholder = R.string.localizable.user_input_details_placeholder_phoneNumber()
        phoneNumber.snp.makeConstraints { make in
            make.top.equalTo(city.snp.bottom).offset(23)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-12)
        }

        scrollView.addSubview(additionalRequest)
        additionalRequest.withBottomBorder()
        additionalRequest.placeholder = R.string.localizable.seeker_request_create_placeholder_information()
        additionalRequest.snp.makeConstraints { make in
            make.top.equalTo(phoneNumber.snp.bottom).offset(23)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
        }

        scrollView.addSubview(deliveryComment)
        deliveryComment.withBottomBorder()
        deliveryComment.placeholder = R.string.localizable.user_input_details_placeholder_phoneNumber()
        deliveryComment.snp.makeConstraints { make in
            make.top.equalTo(additionalRequest.snp.bottom).offset(23)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
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

    override func bind(viewModel: RequestConfirmationViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.titleText.drive(titleLabel.rx.attributedText)
        )
    }
}
