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
        let requestService: HelpRequestsService
        let items: [Item]
        let onSuccess: (() -> Void)?
        let onError: ((Error) -> Void)?

        let titleText = Driver.just(R.string.localizable.seeker_detail_screen_title().asHeading())

        init(navigator: ScreenNavigating,
             requestService: HelpRequestsService,
             items: [Item],
             onSuccess: (() -> Void)? = nil,
             onError: ((Error) -> Void)? = nil) {
            self.navigator = navigator
            self.requestService = requestService
            self.items = items
            self.onSuccess = onSuccess
            self.onError = onError
        }

        func confirm(street: String?,
                     number: String?,
                     zipCode: String?,
                     city: String?,
                     phoneNumber: String?,
                     additionalRequest: String?,
                     deliveryComment: String?) -> Completable {
            let requestItems = items
                .filter { $0.amount > 0 }
                .map { item in HelpRequestsService.RequestItem(itemId: item.itemId, articleCount: item.amount) }

            let request = HelpRequestsService.Request(street: street,
                                                 number: number,
                                                 zipCode: zipCode,
                                                 city: city,
                                                 items: requestItems,
                                                 additionalRequest: additionalRequest,
                                                 deliveryComment: deliveryComment,
                                                 phoneNumber: phoneNumber)

            return requestService.submitRequest(request: request)
                .asCompletable()
                .do(onError: { [weak self] error in
                    log.error("Error: \(error)")
                    self?.onError?(error)
                }, onCompleted: { [weak self] in
                    log.debug("Succesful:")
                    self?.onSuccess?()
                })
                .catchError { _ in Completable.empty() }
        }
    }

    private var keyboardObserver: KeyboardObserver?

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

    private let confirmButton = ConfirmButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.nexdGreen()
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.left.equalTo(view).inset(35)
        }

        stackView.asCard()
        stackView.alignment = .center
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(23)
            make.left.right.equalTo(view).inset(13)
        }

        guard let items = viewModel?.items else { return }
        for item in items {
            let itemView = RequestConfirmationItemView()
            itemView.title.attributedText = "\(item.title)".asListItemTitle()
            itemView.amount.attributedText = "\(item.amount)x".asListItemDetails()

            stackView.addArrangedSubview(itemView)

            itemView.snp.makeConstraints { make in
                make.left.equalTo(view).inset(13)
                make.height.equalTo(52)
            }
        }

        scrollView.addSubview(street)
        street.withBottomBorder()
        street.placeholder = R.string.localizable.user_input_details_placeholder_street()
        street.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(stackView.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(13)
        }

        scrollView.addSubview(number)
        number.withBottomBorder()
        number.placeholder = R.string.localizable.user_input_details_placeholder_houseNumber()
        number.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(street.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(13)
        }

        scrollView.addSubview(zipCode)
        zipCode.withBottomBorder()
        zipCode.placeholder = R.string.localizable.user_input_details_placeholder_zipCode()
        zipCode.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(number.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(13)
        }

        scrollView.addSubview(city)
        city.withBottomBorder()
        city.placeholder = R.string.localizable.user_input_details_placeholder_city()
        city.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(zipCode.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(13)
        }

        scrollView.addSubview(phoneNumber)
        phoneNumber.withBottomBorder()
        phoneNumber.placeholder = R.string.localizable.user_input_details_placeholder_phoneNumber()
        phoneNumber.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(city.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(13)
        }

        scrollView.addSubview(additionalRequest)
        additionalRequest.withBottomBorder()
        additionalRequest.placeholder = R.string.localizable.seeker_request_create_placeholder_information()
        additionalRequest.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(phoneNumber.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(13)
        }

        scrollView.addSubview(deliveryComment)
        deliveryComment.withBottomBorder()
        deliveryComment.placeholder = R.string.localizable.seeker_request_create_placeholder_delivery_comment()
        deliveryComment.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(additionalRequest.snp.bottom).offset(23)
            make.left.equalToSuperview().inset(13)
        }

        scrollView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.left.equalTo(34)
            make.top.equalTo(deliveryComment.snp.bottom).offset(44)
            make.bottom.equalToSuperview().offset(-23)
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
            viewModel.titleText.drive(titleLabel.rx.attributedText),
            confirmButton.rx.controlEvent(.touchUpInside)
                .flatMap { [weak self] _ -> Completable in
                    guard let self = self else { return .empty() }
                    return viewModel.confirm(street: self.street.text,
                                             number: self.number.text,
                                             zipCode: self.zipCode.text,
                                             city: self.city.text,
                                             phoneNumber: self.phoneNumber.text,
                                             additionalRequest: self.additionalRequest.text,
                                             deliveryComment: self.deliveryComment.text)
                }
                .subscribe()
        )
    }
}
