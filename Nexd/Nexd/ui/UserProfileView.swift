//
//  UserProfileViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 03.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack {
                NexdUI.Texts.title(text: R.string.localizable.user_profile_screen_title.text)
                    .padding([.top, .leading, .trailing], 42)

                Group {
                    NexdUI.ValidatingTextField(tag: 0,
                                               text: $viewModel.state.firstName,
                                               placeholder: R.string.localizable.registration_placeholder_firstName(),
                                               icon: R.image.person1(),
                                               validationRules: .firstName,
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(tag: 1,
                                               text: $viewModel.state.lastName,
                                               placeholder: R.string.localizable.registration_placeholder_lastName(),
                                               icon: R.image.person1(),
                                               validationRules: .lastName,
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(tag: 2,
                                               text: $viewModel.state.street,
                                               placeholder: R.string.localizable.user_input_details_placeholder_street(),
                                               icon: R.image.person1(),
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .sentences,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasNext: true))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(tag: 3,
                                               text: $viewModel.state.streetNumber,
                                               placeholder: R.string.localizable.user_input_details_placeholder_houseNumber(),
                                               icon: R.image.hashtag(),
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(tag: 4,
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

                    NexdUI.ValidatingTextField(tag: 5,
                                               text: $viewModel.state.city,
                                               placeholder: R.string.localizable.user_input_details_placeholder_city(),
                                               icon: R.image.person1(),
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(tag: 6,
                                               text: $viewModel.state.phoneNumber,
                                               placeholder: R.string.localizable.user_input_details_placeholder_phoneNumber(),
                                               icon: R.image.hashtag(),
                                               validationRules: .phone,
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

                NexdUI.Buttons.solidLightButton(text: R.string.localizable.confirm_button_title.text) {
                    self.viewModel.confirmButtonTapped()
                }
                .padding(.top, 34)
                .padding([.leading, .trailing], 12)

                NexdUI.Buttons.solidLightButton(text: R.string.localizable.user_profile_button_title_logout.text) {
                    self.viewModel.logoutButtonTapped()
                }
                .padding(12)
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

extension UserProfileView {
    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var firstName: String?
            @Published var lastName: String?
            @Published var street: String?
            @Published var streetNumber: String?
            @Published var zipCode: String?
            @Published var city: String?
            @Published var phoneNumber: String?
            @Published var dialog: Dialog?
        }

        private let navigator: ScreenNavigating
        private let authenticationService: AuthenticationService
        private let userService: UserService
        private var onFinished: ((Bool) -> Void)?

        private var cancellableSet: Set<AnyCancellable>?

        var state = ViewState()

        init(navigator: ScreenNavigating, authenticationService: AuthenticationService, userService: UserService, onFinished: ((Bool) -> Void)?) {
            self.navigator = navigator
            self.authenticationService = authenticationService
            self.userService = userService
            self.onFinished = onFinished
        }

        func confirmButtonTapped() {
            log.debug("Send user information to backend")

            cancellableSet?.insert(
                userService.updateUserInformation(firstName: state.firstName,
                                                  lastName: state.lastName,
                                                  street: state.street,
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
                            self?.onFinished?(false)
                        },
                        receiveValue: { _ in }
                    )
            )
        }

        func logoutButtonTapped() {
            authenticationService.logout()
            onFinished?(true)
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            cancellableSet.insert(
                userService.findMe()
                    .publisher
                    .receive(on: RunLoop.main)
                    .sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                log.error("UserInformation update failed: \(error)")
                            }
                        },
                        receiveValue: { [weak self] profile in
                            self?.state.firstName = profile.firstName
                            self?.state.lastName = profile.lastName
                            self?.state.phoneNumber = profile.phoneNumber
                            self?.state.street = profile.street
                            self?.state.streetNumber = profile.number
                            self?.state.zipCode = profile.zipCode
                            self?.state.city = profile.city
                        }
                    ))

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

    static func createScreen(viewModel: UserProfileView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: UserProfileView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

#if DEBUG
    struct UserProfileView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = UserProfileView.ViewModel(navigator: PreviewNavigator(),
                                                      authenticationService: AuthenticationService(storage: PersistentStorage(userDefaults: UserDefaults.standard)),
                                                      userService: UserService(),
                                                      onFinished: { _ in })
            return Group {
                UserProfileView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                UserProfileView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                UserProfileView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
