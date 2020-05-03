//
//  LoginView.swift
//  nexd
//
//  Created by Julian Manke on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import SwiftUI
import Validator

struct LoginView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return VStack {
            R.image.logo.image
                .padding([.top, .leading, .trailing], 42)

            Group {
                NexdUI.ValidatingTextField(style: .onboarding,
                                           tag: 0,
                                           text: $viewModel.state.username,
                                           placeholder: R.string.localizable.login_placeholder_username(),
                                           icon: R.image.person1(),
                                           validationRules: .email,
                                           inputConfiguration: NexdUI.InputConfiguration(keyboardType: .emailAddress,
                                                                                         autocapitalizationType: .none,
                                                                                         autocorrectionType: .no,
                                                                                         spellCheckingType: .no,
                                                                                         hasPrevious: false,
                                                                                         hasNext: true))
                    .padding(.top, 160)

                NexdUI.ValidatingTextField(style: .onboarding,
                                           tag: 1,
                                           text: $viewModel.state.password,
                                           placeholder: R.string.localizable.login_placeholder_password(),
                                           icon: R.image.lock2(),
                                           validationRules: .password,
                                           inputConfiguration: NexdUI.InputConfiguration(isSecureTextEntry: true,
                                                                                         autocapitalizationType: .none,
                                                                                         autocorrectionType: .no,
                                                                                         spellCheckingType: .no,
                                                                                         hasPrevious: true, hasNext: false,
                                                                                         hasDone: true))
                    .padding(.top, 34)
            }
            .padding([.leading, .trailing], 28)

            Spacer()

            NexdUI.Buttons.solidButton(text: R.string.localizable.login_button_title_login.text) {
                self.viewModel.loginButtonTapped()
            }
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

extension LoginView {
    struct Dialog: Identifiable {
        var id = UUID()
        let title: String
        let message: String
    }

    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var username: String?
            @Published var password: String?
            @Published var dialog: Dialog?
        }

        private let navigator: ScreenNavigating
        private var cancellableSet: Set<AnyCancellable>?

        var state = ViewState()

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }

        func loginButtonTapped() {
            guard let email = state.username, let password = state.password else {
                log.warning("Missing mandatory login information!")
                return
            }

            guard email.validate(rules: .email).isValid, password.validate(rules: .password).isValid else {
                state.dialog = Dialog(title: R.string.localizable.error_title(),
                                      message: R.string.localizable.error_message_registration_validation_failed())
                return
            }

            cancellableSet?.insert(
                AuthenticationService.shared.login(email: email, password: password)
                    .publisher
                    .sink(
                        receiveCompletion: { [weak self] completion in
                            if case let .failure(error) = completion {
                                log.error("Login failed: \(error)")
                                self?.state.dialog = Dialog(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_login_failed())
                                return
                            }

                            log.debug("Login successful!")
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

    static func createScreen(viewModel: LoginView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: LoginView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.defaultBackground()
        return screen
    }
}

#if DEBUG
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = LoginView.ViewModel(navigator: PreviewNavigator())
            return Group {
                LoginView(viewModel: viewModel)
                    .background(R.color.defaultBackground.color)
                    .environment(\.locale, .init(identifier: "de"))

                LoginView(viewModel: viewModel)
                    .background(R.color.defaultBackground.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                LoginView(viewModel: viewModel)
                    .background(R.color.defaultBackground.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
