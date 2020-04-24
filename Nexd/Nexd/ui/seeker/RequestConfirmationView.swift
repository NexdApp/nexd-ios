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
import SwiftUI

struct RequestConfirmationView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return
            ScrollView {
                VStack {
                    NexdUI.Headings.title(text: R.string.localizable.seeker_detail_screen_title.text)
                        .padding(.top, 75)
                        .padding(.leading, 35)

                    NexdUI.Card {
                        VStack {
                            ForEach(viewModel.items) { item in
                                HStack {
                                    Text(item.title)
                                        .padding(.trailing, 8)
                                        .font(R.font.proximaNovaSoftBold.font(size: 18))
                                        .foregroundColor(R.color.listItemTitle.color)

                                    Spacer()

                                    Text("\(item.amount)x")
                                        .font(R.font.proximaNovaSoftBold.font(size: 14))
                                        .foregroundColor(R.color.listItemDetailsText.color)
                                }
                                .frame(height: 52)
                            }
                        }
                        .padding([.top, .bottom], 8)
                    }
                    .padding(.top, 23)
                    .padding([.leading, .trailing], 13)

                        NexdUI.ValidatingTextField(tag: 0,
                                                   placeholder: "Test: Phone",
                                                   onChanged: { string in log.debug("onChanged: \(string)") },
                                                   inputValidation: NexdUI.InputValidation(rules: .phone,
                                                                                                               handler: { result in
                                                                       switch result {
                                                                       case .valid:
                                                   //                        view.state = .normal
                                                                           log.debug("Validatiion: OK")
                                                                       case let .invalid(failureErrors):
                                                                           let messages = failureErrors.map { $0.message }

                                                                           log.debug("Validatiion failed: \(String(describing: messages.first))")
                                                   //                        view.state = .error(messages.first)
                                                                       }
                                                                   }))


                    NexdUI.TextField(tag: 0,
                                     placeholder: R.string.localizable.transcribe_info_input_text_title_first_name(),
                                     onChanged: { string in log.debug(string) })
                        .padding(.top, 12)

                }
        }
    }

//    private var keyboardObserver: KeyboardObserver?
//
//    private let scrollView = UIScrollView()
//    private let titleLabel = UILabel()
//    private let stackView = UIStackView()
//    private let firstName = TextField()
//    private let lastName = TextField()
//    private let street = TextField()
//    private let number = TextField()
//    private let zipCode = TextField()
//    private let city = TextField()
//    private let phoneNumber = TextField()
//    private let additionalRequest = TextField()
//    private let deliveryComment = TextField()
//
//    private let confirmButton = ConfirmButton()

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = R.color.nexdGreen()
//        view.addSubview(scrollView)
//
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        scrollView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(75)
//            make.left.equalTo(view).inset(35)
//        }
//
//        stackView.asCard()
//        stackView.alignment = .center
//        stackView.axis = .vertical
//        scrollView.addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(23)
//            make.left.right.equalTo(view).inset(13)
//        }
//
//        guard let items = viewModel?.items else { return }
//        for item in items {
//            let itemView = RequestConfirmationItemView()
//            itemView.title.attributedText = "\(item.title)".asListItemTitle()
//            itemView.amount.attributedText = "\(item.amount)x".asListItemDetails()
//
//            stackView.addArrangedSubview(itemView)
//
//            itemView.snp.makeConstraints { make in
//                make.left.equalTo(view).inset(13)
//                make.height.equalTo(52)
//            }
//        }
//
//        scrollView.addSubview(firstName)
//        firstName.withBottomBorder()
//        firstName.placeholder = R.string.localizable.user_input_details_placeholder_firstname()
//        firstName.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.top.equalTo(stackView.snp.bottom).offset(23)
//            make.left.equalToSuperview().inset(13)
//        }
//
//        scrollView.addSubview(lastName)
//        lastName.withBottomBorder()
//        lastName.placeholder = R.string.localizable.user_input_details_placeholder_lastname()
//        lastName.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.top.equalTo(firstName.snp.bottom).offset(23)
//            make.left.equalToSuperview().inset(13)
//        }
//
//        scrollView.addSubview(street)
//        street.withBottomBorder()
//        street.placeholder = R.string.localizable.user_input_details_placeholder_street()
//        street.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.top.equalTo(lastName.snp.bottom).offset(23)
//            make.left.equalToSuperview().inset(13)
//        }
//
//        scrollView.addSubview(number)
//        number.withBottomBorder()
//        number.placeholder = R.string.localizable.user_input_details_placeholder_houseNumber()
//        number.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.top.equalTo(street.snp.bottom).offset(23)
//            make.left.equalToSuperview().inset(13)
//        }
//
//        scrollView.addSubview(zipCode)
//        zipCode.withBottomBorder()
//        zipCode.placeholder = R.string.localizable.user_input_details_placeholder_zipCode()
//        zipCode.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.top.equalTo(number.snp.bottom).offset(23)
//            make.left.equalToSuperview().inset(13)
//        }
//
//        scrollView.addSubview(city)
//        city.withBottomBorder()
//        city.placeholder = R.string.localizable.user_input_details_placeholder_city()
//        city.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.top.equalTo(zipCode.snp.bottom).offset(23)
//            make.left.equalToSuperview().inset(13)
//        }
//
//        scrollView.addSubview(phoneNumber)
//        phoneNumber.withBottomBorder()
//        phoneNumber.placeholder = R.string.localizable.user_input_details_placeholder_phoneNumber()
//        phoneNumber.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.top.equalTo(city.snp.bottom).offset(23)
//            make.left.equalToSuperview().inset(13)
//        }
//
//        scrollView.addSubview(additionalRequest)
//        additionalRequest.withBottomBorder()
//        additionalRequest.placeholder = R.string.localizable.seeker_request_create_placeholder_information()
//        additionalRequest.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.top.equalTo(phoneNumber.snp.bottom).offset(23)
//            make.left.equalToSuperview().inset(13)
//        }
//
//        scrollView.addSubview(deliveryComment)
//        deliveryComment.withBottomBorder()
//        deliveryComment.placeholder = R.string.localizable.seeker_request_create_placeholder_delivery_comment()
//        deliveryComment.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.top.equalTo(additionalRequest.snp.bottom).offset(23)
//            make.left.equalToSuperview().inset(13)
//        }
//
//        scrollView.addSubview(confirmButton)
//        confirmButton.snp.makeConstraints { make in
//            make.height.equalTo(36)
//            make.left.equalTo(34)
//            make.top.equalTo(deliveryComment.snp.bottom).offset(44)
//            make.bottom.equalToSuperview().offset(-23)
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
//    override func bind(viewModel: RequestConfirmationViewController.ViewModel, disposeBag: DisposeBag) {
//        disposeBag.insert(
//            viewModel.titleText.drive(titleLabel.rx.attributedText),
//            viewModel.firstName.drive(firstName.rx.text),
//            viewModel.lastName.drive(lastName.rx.text),
//            viewModel.street.drive(street.rx.text),
//            viewModel.number.drive(number.rx.text),
//            viewModel.zipCode.drive(zipCode.rx.text),
//            viewModel.city.drive(city.rx.text),
//            viewModel.phoneNumber.drive(phoneNumber.rx.text),
//            confirmButton.rx.controlEvent(.touchUpInside)
//                .flatMap { [weak self] _ -> Completable in
//                    guard let self = self else { return .empty() }
//                    return viewModel.confirm(firstName: self.firstName.text,
//                                             lastName: self.lastName.text,
//                                             street: self.street.text,
//                                             number: self.number.text,
//                                             zipCode: self.zipCode.text,
//                                             city: self.city.text,
//                                             phoneNumber: self.phoneNumber.text,
//                                             additionalRequest: self.additionalRequest.text,
//                                             deliveryComment: self.deliveryComment.text)
//                }
//                .subscribe()
//        )
//    }
}

extension RequestConfirmationView {
    struct Item: Identifiable {
        let id: Int64
        let title: String
        let amount: Int64
    }

    class ViewModel: ObservableObject {
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
                .map { item in HelpRequestsService.RequestItem(itemId: item.id, articleCount: item.amount) }

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

    static func createScreen(viewModel: RequestConfirmationView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: RequestConfirmationView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

#if DEBUG
    struct RequestConfirmationView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = RequestConfirmationView.ViewModel(navigator: PreviewNavigator(),
                                                              userService: UserService(),
                                                              helpRequestsService: HelpRequestsService(),
                                                              items: [RequestConfirmationView.Item(id: 0, title: "Klopapier", amount: 10),
                                                                      RequestConfirmationView.Item(id: 1, title: "Zwiebeln", amount: 3),
                                                                      RequestConfirmationView.Item(id: 2, title: "Tomaten", amount: 25),
                                                                      RequestConfirmationView.Item(id: 3, title: "Hefe", amount: 8)])
            return Group {
                RequestConfirmationView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                RequestConfirmationView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                RequestConfirmationView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
