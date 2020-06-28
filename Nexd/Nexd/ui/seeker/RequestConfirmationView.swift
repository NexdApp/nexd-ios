//
//  RequestConfirmationViewController.swift
//  nexd
//
//  Created by Tobias Schröpf on 11.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
//import RxCocoa
import RxSwift
import SwiftUI

struct RequestConfirmationView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return
            ScrollView {
                VStack {
                    NexdUI.Texts.title(text: R.string.localizable.seeker_detail_screen_title.text)
                        .padding(.top, 75)
                        .padding(.leading, 35)

                    NexdUI.Card {
                        VStack {
                            ForEach(viewModel.state.items) { item in
                                HStack {
                                    Text(item.name)
                                        .padding(.trailing, 8)
                                        .font(R.font.proximaNovaBold.font(size: 18))
                                        .foregroundColor(R.color.listItemTitle.color)

                                    Spacer()

                                    Text(String(item.amount))
                                        .font(R.font.proximaNovaBold.font(size: 14))
                                        .foregroundColor(R.color.listItemDetailsText.color)

                                    item.unit.map { unit in
                                        Text(String(unit.nameShort))
                                            .font(R.font.proximaNovaBold.font(size: 14))
                                            .foregroundColor(R.color.listItemDetailsText.color)
                                    }
                                }
                                .frame(height: 52)
                            }
                        }
                        .padding([.top, .bottom], 8)
                    }
                    .padding(.top, 23)
                    .padding([.leading, .trailing], 13)

                    Group {
                        NexdUI.ValidatingTextField(tag: 0,
                                                   text: $viewModel.state.firstName,
                                                   placeholder: R.string.localizable.user_input_details_placeholder_firstname(),
                                                   validationRules: .firstName,
                                                   inputConfiguration: NexdUI.InputConfiguration(keyboardType: .alphabet,
                                                                                                 autocorrectionType: .no,
                                                                                                 spellCheckingType: .no,
                                                                                                 hasPrevious: false,
                                                                                                 hasNext: true))

                        NexdUI.ValidatingTextField(tag: 1,
                                                   text: $viewModel.state.lastName,
                                                   placeholder: R.string.localizable.user_input_details_placeholder_lastname(),
                                                   validationRules: .lastName,
                                                   inputConfiguration: NexdUI.InputConfiguration(keyboardType: .alphabet,
                                                                                                 autocorrectionType: .no,
                                                                                                 spellCheckingType: .no,
                                                                                                 hasPrevious: true,
                                                                                                 hasNext: true))

                        NexdUI.ValidatingTextField(tag: 2,
                                                   text: $viewModel.state.street,
                                                   placeholder: R.string.localizable.user_input_details_placeholder_street(),
                                                   validationRules: nil,
                                                   inputConfiguration: NexdUI.InputConfiguration(keyboardType: .default,
                                                                                                 autocorrectionType: .no,
                                                                                                 spellCheckingType: .no,
                                                                                                 hasPrevious: true,
                                                                                                 hasNext: true))

                        NexdUI.ValidatingTextField(tag: 3,
                                                   text: $viewModel.state.houseNumber,
                                                   placeholder: R.string.localizable.user_input_details_placeholder_houseNumber(),
                                                   validationRules: nil,
                                                   inputConfiguration: NexdUI.InputConfiguration(keyboardType: .default,
                                                                                                 autocorrectionType: .no,
                                                                                                 spellCheckingType: .no,
                                                                                                 hasPrevious: true,
                                                                                                 hasNext: true))

                        NexdUI.ValidatingTextField(tag: 4,
                                                   text: $viewModel.state.zipCode,
                                                   placeholder: R.string.localizable.user_input_details_placeholder_zipCode(),
                                                   validationRules: .zipCode,
                                                   inputConfiguration: NexdUI.InputConfiguration(keyboardType: .numberPad,
                                                                                                 autocapitalizationType: .none,
                                                                                                 autocorrectionType: .no,
                                                                                                 spellCheckingType: .no,
                                                                                                 hasPrevious: true,
                                                                                                 hasNext: true))

                        NexdUI.ValidatingTextField(tag: 5,
                                                   text: $viewModel.state.city,
                                                   placeholder: R.string.localizable.user_input_details_placeholder_city(),
                                                   validationRules: nil,
                                                   inputConfiguration: NexdUI.InputConfiguration(keyboardType: .default,
                                                                                                 autocorrectionType: .no,
                                                                                                 spellCheckingType: .no,
                                                                                                 hasPrevious: true,
                                                                                                 hasNext: true))

                        NexdUI.ValidatingTextField(tag: 6,
                                                   text: $viewModel.state.phoneNumber,
                                                   placeholder: R.string.localizable.user_input_details_placeholder_phoneNumber(),
                                                   validationRules: .phone,
                                                   inputConfiguration: NexdUI.InputConfiguration(keyboardType: .phonePad,
                                                                                                 autocorrectionType: .no,
                                                                                                 spellCheckingType: .no,
                                                                                                 hasPrevious: true,
                                                                                                 hasNext: true))

                        NexdUI.TextField(tag: 7,
                                         text: $viewModel.state.information,
                                         placeholder: R.string.localizable.seeker_request_create_placeholder_information(),
                                         inputConfiguration: NexdUI.InputConfiguration(hasPrevious: true, hasNext: true))

                        NexdUI.TextField(tag: 8,
                                         text: $viewModel.state.deliveryComment,
                                         placeholder: R.string.localizable.seeker_request_create_placeholder_delivery_comment(),
                                         inputConfiguration: NexdUI.InputConfiguration(hasPrevious: true, hasNext: false, hasDone: true))
                    }
                    .padding(.top, 8)
                    .padding([.leading, .trailing], 13)

                    NexdUI.Buttons.confirm {
                        self.viewModel.onConfirmButtonTapped()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 33)
                    .padding(.bottom, 53)
                    .padding(.leading, 35)
                }
            }
            .keyboardAdaptive()
            .dismissingKeyboard()
            .onAppear { self.viewModel.bind() }
            .onDisappear { self.viewModel.unbind() }
    }
}

extension RequestConfirmationView {
    struct Item: Identifiable {
        let id = UUID()

        let article: Article?
        let name: String
        let amount: Int64
        let unitId: Int64?

        var dto: CreateHelpRequestArticleDto {
            guard let article = article else {
                return CreateHelpRequestArticleDto(articleId: nil,
                                                   articleName: name,
                                                   language: AvailableLanguages.current,
                                                   articleCount: amount,
                                                   unitId: unitId)
            }

            return CreateHelpRequestArticleDto(articleId: article.id,
                                               articleName: nil,
                                               language: nil,
                                               articleCount: amount,
                                               unitId: nil)
        }
    }

    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating
        private let userService: UserService
        private let helpRequestsService: HelpRequestsService
        private let onSuccess: (() -> Void)?
        private let onError: ((Error) -> Void)?

        private var cancellableSet: Set<AnyCancellable>?

        var state: HelpRequestCreationState

        private lazy var profile = userService.findMe().asObservable().share(replay: 1).publisher

        init(navigator: ScreenNavigating,
             userService: UserService,
             helpRequestsService: HelpRequestsService,
             state: HelpRequestCreationState,
             onSuccess: (() -> Void)? = nil,
             onError: ((Error) -> Void)? = nil) {
            self.navigator = navigator
            self.userService = userService
            self.helpRequestsService = helpRequestsService
            self.state = state
            self.onSuccess = onSuccess
            self.onError = onError
        }

        func onConfirmButtonTapped() {
            cancellableSet?.insert(
                confirm()
                    .publisher
                    .sink(
                        receiveCompletion: { [weak self] completion in
                            if case let .failure(error) = completion {
                                log.error("Creating help request failed: \(error)")
                                self?.onError?(error)
                                return
                            }

                            self?.onSuccess?()
                        },
                        receiveValue: { _ in }
                    )
            )
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            profile
                .map { profile -> String? in profile.firstName }
                .replaceError(with: nil)
                .assign(to: \.firstName, on: state)
                .store(in: &cancellableSet)

            profile
                .map { profile -> String? in profile.lastName }
                .replaceError(with: nil)
                .assign(to: \.lastName, on: state)
                .store(in: &cancellableSet)

            profile
                .map { profile -> String? in profile.street }
                .replaceError(with: nil)
                .assign(to: \.street, on: state)
                .store(in: &cancellableSet)

            profile
                .map { profile -> String? in profile.number }
                .replaceError(with: nil)
                .assign(to: \.houseNumber, on: state)
                .store(in: &cancellableSet)

            profile
                .map { profile -> String? in profile.zipCode }
                .replaceError(with: nil)
                .assign(to: \.zipCode, on: state)
                .store(in: &cancellableSet)

            profile
                .map { profile -> String? in profile.city }
                .replaceError(with: nil)
                .assign(to: \.city, on: state)
                .store(in: &cancellableSet)

            profile
                .map { profile -> String? in profile.phoneNumber }
                .replaceError(with: nil)
                .assign(to: \.phoneNumber, on: state)
                .store(in: &cancellableSet)

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

        private func confirm() -> Completable {
            return helpRequestsService.submitRequest(dto: state.dto)
                .asCompletable()
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
                                                              state: HelpRequestCreationState())
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
