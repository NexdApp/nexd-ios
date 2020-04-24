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
        private let navigator: ScreenNavigating
        private let userService: UserService
        private let helpRequestsService: HelpRequestsService
        fileprivate let items: [Item]
        private let onSuccess: (() -> Void)?
        private let onError: ((Error) -> Void)?

        private lazy var profile = userService.findMe().asObservable().share(replay: 1)

        let titleText = Driver.just(R.string.localizable.seeker_detail_screen_title().asHeading())
        var firstName: Driver<String?> { profile.map { $0.firstName }.asDriver(onErrorJustReturn: nil) }
        var lastName: Driver<String?> { profile.map { $0.lastName }.asDriver(onErrorJustReturn: nil) }
        var street: Driver<String?> { profile.map { $0.street }.asDriver(onErrorJustReturn: nil) }
        var number: Driver<String?> { profile.map { $0.number }.asDriver(onErrorJustReturn: nil) }
        var zipCode: Driver<String?> { profile.map { $0.zipCode }.asDriver(onErrorJustReturn: nil) }
        var city: Driver<String?> { profile.map { $0.city }.asDriver(onErrorJustReturn: nil) }
        var phoneNumber: Driver<String?> { profile.map { $0.phoneNumber }.asDriver(onErrorJustReturn: nil) }

        init(navigator: ScreenNavigating,
             userService: UserService,
             helpRequestsService: HelpRequestsService,
             items: [Item],
             onSuccess: (() -> Void)? = nil,
             onError: ((Error) -> Void)? = nil) {
            self.navigator = navigator
            self.userService = userService
            self.helpRequestsService = helpRequestsService
            self.items = items
            self.onSuccess = onSuccess
            self.onError = onError
        }

        func confirm(firstName: String?,
                     lastName: String?,
                     street: String?,
                     number: String?,
                     zipCode: String?,
                     city: String?,
                     phoneNumber: String?,
                     additionalRequest: String?,
                     deliveryComment: String?) -> Completable {
            let requestItems = items
                .filter { $0.amount > 0 }
                .map { item in HelpRequestsService.RequestItem(itemId: item.itemId, articleCount: item.amount) }

            let request = HelpRequestsService.Request(firstName: firstName,
                                                      lastName: lastName,
                                                      street: street,
                                                      number: number,
                                                      zipCode: zipCode,
                                                      city: city,
                                                      items: requestItems,
                                                      additionalRequest: additionalRequest,
                                                      deliveryComment: deliveryComment,
                                                      phoneNumber: phoneNumber)

            return helpRequestsService.submitRequest(request: request)
                .asCompletable()
                .do(onError: { [weak self] error in
                    log.error("Error: \(error)")
                    self?.onError?(error)
                }, onCompleted: { [weak self] in
                    self?.onSuccess?()
                })
                .catchError { _ in Completable.empty() }
        }
    }

    private var keyboardObserver: KeyboardObserver?
    private var textFieldTags: Int = 0

    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let firstName = TextField()
    private let lastName = TextField()
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
        let textFields = [firstName, lastName, street, number, zipCode, city, phoneNumber, additionalRequest, deliveryComment]
        for (index, textView) in textFields.enumerated() {
            scrollView.addSubview(textView)
            textView.withBottomBorder()
            textView.snp.makeConstraints { make in
                make.height.equalTo(36)
                make.left.equalToSuperview().inset(13)
            }
            textView.tag = index
            textView.delegate = self
            if textView == textFields.last {
                textView.returnKeyType = .done
            }
            print("DEBUG: \(textView.tag)")
        }
        addInputAccessoryForTextFields(textFields: textFields, dismissable: true, previousNextable: true)

        firstName.placeholder = R.string.localizable.user_input_details_placeholder_firstname()
        firstName.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(23)
        }

        lastName.placeholder = R.string.localizable.user_input_details_placeholder_lastname()
        lastName.snp.makeConstraints { make in
            make.top.equalTo(firstName.snp.bottom).offset(23)
        }
        street.placeholder = R.string.localizable.user_input_details_placeholder_street()
        street.snp.makeConstraints { make in
            make.top.equalTo(lastName.snp.bottom).offset(23)
        }

        number.placeholder = R.string.localizable.user_input_details_placeholder_houseNumber()
        number.snp.makeConstraints { make in
            make.top.equalTo(street.snp.bottom).offset(23)
        }
        number.keyboardType = .numberPad

        zipCode.placeholder = R.string.localizable.user_input_details_placeholder_zipCode()
        zipCode.snp.makeConstraints { make in
            make.top.equalTo(number.snp.bottom).offset(23)
        }
        zipCode.keyboardType = .numberPad
        city.placeholder = R.string.localizable.user_input_details_placeholder_city()
        city.snp.makeConstraints { make in
            make.top.equalTo(zipCode.snp.bottom).offset(23)
        }

        phoneNumber.placeholder = R.string.localizable.user_input_details_placeholder_phoneNumber()
        phoneNumber.snp.makeConstraints { make in
            make.top.equalTo(city.snp.bottom).offset(23)
        }
        phoneNumber.keyboardType = .phonePad
        phoneNumber.returnKeyType = .default
        additionalRequest.placeholder = R.string.localizable.seeker_request_create_placeholder_information()
        additionalRequest.snp.makeConstraints { make in
            make.top.equalTo(phoneNumber.snp.bottom).offset(23)
        }

        deliveryComment.placeholder = R.string.localizable.seeker_request_create_placeholder_delivery_comment()
        deliveryComment.snp.makeConstraints { make in
            make.top.equalTo(additionalRequest.snp.bottom).offset(23)
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
            viewModel.firstName.drive(firstName.rx.text),
            viewModel.lastName.drive(lastName.rx.text),
            viewModel.street.drive(street.rx.text),
            viewModel.number.drive(number.rx.text),
            viewModel.zipCode.drive(zipCode.rx.text),
            viewModel.city.drive(city.rx.text),
            viewModel.phoneNumber.drive(phoneNumber.rx.text),
            confirmButton.rx.controlEvent(.touchUpInside)
                .flatMap { [weak self] _ -> Completable in
                    guard let self = self else { return .empty() }
                    return viewModel.confirm(firstName: self.firstName.text,
                                             lastName: self.lastName.text,
                                             street: self.street.text,
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
extension RequestConfirmationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("DEBUG: \(textField.tag)")
        if let nextResponder = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return false
    }
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "chevron_left"), style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                let nextButton = UIBarButtonItem(image: UIImage(named: "Chevron"), style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
}
