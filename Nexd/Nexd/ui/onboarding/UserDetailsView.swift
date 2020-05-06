//
//  UserDetailsViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import SwiftUI

struct UserDetailsView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack {
                R.image.logo.image
                    .padding([.top, .leading, .trailing], 42)

                Group {
                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 0,
                                               text: $viewModel.state.street,
                                               placeholder: R.string.localizable.user_input_details_placeholder_street(),
                                               icon: R.image.person1(),
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .sentences,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasNext: true))
                        .padding(.top, 42)

                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 1,
                                               text: $viewModel.state.streetNumber,
                                               placeholder: R.string.localizable.user_input_details_placeholder_houseNumber(),
                                               icon: R.image.hashtag(),
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 2,
                                               text: $viewModel.state.zipCode,
                                               placeholder: R.string.localizable.user_input_details_placeholder_zipCode(),
                                               icon: R.image.hashtag(),
                                               validationRules: .zipCode,
                                               inputConfiguration: NexdUI.InputConfiguration(keyboardType: .numberPad,
                                                                                             autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 3,
                                               text: $viewModel.state.city,
                                               placeholder: R.string.localizable.user_input_details_placeholder_city(),
                                               icon: R.image.person1(),
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 4,
                                               text: $viewModel.state.phoneNumber,
                                               placeholder: R.string.localizable.user_input_details_placeholder_phoneNumber(),
                                               icon: R.image.hashtag(),
                                               inputConfiguration: NexdUI.InputConfiguration(keyboardType: .phonePad,
                                                                                             autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasDone: true))
                        .padding(.top, 34)
                }
                .padding([.leading, .trailing], 28)

                Spacer()

                NexdUI.Buttons.solidButton(text: R.string.localizable.user_input_details_confirm.text) {
                    self.viewModel.continueButtonTapped()
                }
                .padding(.top, 34)
                .padding([.bottom, .leading, .trailing], 12)
            }
            .keyboardAdaptive()
            .dismissingKeyboard()
            .alert(item: $viewModel.state.dialog) { dialog -> Alert in
                Alert(title: Text(dialog.title),
                      message: Text(dialog.message),
                      dismissButton: .default(R.string.localizable.ok_button_title.text))
            }
            .onAppear { self.viewModel.bind() }
            .onDisappear { self.viewModel.unbind() }
        }
    }
}

extension UserDetailsView {
    struct UserInformation {
        let firstName: String
        let lastName: String
    }

    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var street: String?
            @Published var streetNumber: String?
            @Published var zipCode: String?
            @Published var city: String?
            @Published var phoneNumber: String?
            @Published var dialog: Dialog?
        }

        private let navigator: ScreenNavigating
        private let userInformation: UserInformation
        private var cancellableSet: Set<AnyCancellable>?

        var state = ViewState()

        init(navigator: ScreenNavigating, userInformation: UserInformation) {
            self.navigator = navigator
            self.userInformation = userInformation
        }

        func continueButtonTapped() {
            log.debug("Send user information to backend")

            cancellableSet?.insert(
            UserService.shared.updateUserInformation(street: state.street,
                                                     number: state.streetNumber,
                                                     zipCode: state.zipCode,
                                                     city: state.city,
                                                     phoneNumber: state.phoneNumber)
                .publisher
                .sink(
                    receiveCompletion: { [weak self] completion in
                        if case let .failure(error) = completion {
                            log.error("UserInformation update failed: \(error)")
                            self?.state.dialog = Dialog(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
                            return
                        }

                        log.debug("User information updated...")
                        self?.navigator.toMainScreen()
                    },
                    receiveValue: { _ in }
                )
            )
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

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
    }

    static func createScreen(viewModel: UserDetailsView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: UserDetailsView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.defaultBackground()
        return screen
    }
}
