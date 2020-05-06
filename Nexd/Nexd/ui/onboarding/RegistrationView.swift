//
//  ViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Combine
import NexdClient
import SwiftUI
import Validator

struct RegistrationView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack {
                R.image.logo.image
                    .padding([.top, .leading, .trailing], 42)

                Group {
                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 0,
                                               text: $viewModel.state.email,
                                               placeholder: R.string.localizable.registration_placeholder_email(),
                                               icon: R.image.mail1(),
                                               validationRules: .email,
                                               inputConfiguration: NexdUI.InputConfiguration(keyboardType: .emailAddress,
                                                                                             autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: false,
                                                                                             hasNext: true))
                        .padding(.top, 42)

                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 1,
                                               text: $viewModel.state.firstname,
                                               placeholder: R.string.localizable.registration_placeholder_firstName(),
                                               icon: R.image.person1(),
                                               validationRules: .firstName,
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true,
                                                                                             hasDone: false))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 2,
                                               text: $viewModel.state.lastname,
                                               placeholder: R.string.localizable.registration_placeholder_lastName(),
                                               icon: R.image.person1(),
                                               validationRules: .lastName,
                                               inputConfiguration: NexdUI.InputConfiguration(autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true,
                                                                                             hasDone: false))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 3,
                                               text: $viewModel.state.password,
                                               placeholder: R.string.localizable.registration_placeholder_password(),
                                               icon: R.image.lock2(),
                                               validationRules: .password,
                                               inputConfiguration: NexdUI.InputConfiguration(isSecureTextEntry: true,
                                                                                             autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: true,
                                                                                             hasDone: false))
                        .padding(.top, 34)

                    NexdUI.ValidatingTextField(style: .onboarding,
                                               tag: 4,
                                               text: $viewModel.state.confirmPassword,
                                               placeholder: R.string.localizable.registration_placeholder_confirm_password(),
                                               icon: R.image.lock2(),
                                               validationRules: .passwordConfirmation { self.viewModel.state.password ?? "" },
                                               inputConfiguration: NexdUI.InputConfiguration(isSecureTextEntry: true,
                                                                                             autocapitalizationType: .none,
                                                                                             autocorrectionType: .no,
                                                                                             spellCheckingType: .no,
                                                                                             hasPrevious: true,
                                                                                             hasNext: false,
                                                                                             hasDone: true))
                        .padding(.top, 34)

                    HStack {
                        Button(action: viewModel.privacyPolicyCheckboxTapped) {
                            ZStack {
                                Circle()
                                    .stroke(R.color.nexdGreen.color, lineWidth: 3)
                                    .frame(width: 30, height: 30)

                                if viewModel.state.isPrivacyPolicyAccepted {
                                    R.image.baseline_check_black_48pt.image
                                        .resizable()
                                        .foregroundColor(R.color.nexdGreen.color)
                                        .frame(width: 25, height: 25)
                                } else {
                                    EmptyView()
                                }
                            }
                        }

                        PrivacyPolicyText()
                            .padding(.leading, 8)
                            .frame(height: 42)
                    }
                    .padding(.top, 34)
                }
                .padding([.leading, .trailing], 28)

                Spacer()

                NexdUI.Buttons.solidButton(text: R.string.localizable.registration_button_title_continue.text) {
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

extension RegistrationView {
    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var email: String?
            @Published var firstname: String?
            @Published var lastname: String?
            @Published var password: String?
            @Published var confirmPassword: String?
            @Published var isPrivacyPolicyAccepted: Bool = false
            @Published var dialog: Dialog?
        }

        private let navigator: ScreenNavigating
        private var cancellableSet: Set<AnyCancellable>?

        var state = ViewState()

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }

        func privacyPolicyCheckboxTapped() {
            state.isPrivacyPolicyAccepted.toggle()
        }

        func continueButtonTapped() {
            guard state.isPrivacyPolicyAccepted else {
                log.warning("Cannot regitster user! Did not agree to Privacy Policy")
                state.dialog = Dialog(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_did_not_consent_privacy_policy())
                return
            }

            guard let email = state.email,
                let firstName = state.firstname,
                let lastName = state.lastname,
                let password = state.password,
                let confirmPassword = state.confirmPassword else {
                log.warning("Cannot register user, mandatory field is missing!")
                state.dialog = Dialog(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
                return
            }

            guard email.validate(rules: .email).isValid,
                firstName.validate(rules: .firstName).isValid,
                lastName.validate(rules: .lastName).isValid,
                password.validate(rules: .password).isValid,
                confirmPassword.validate(rules: .passwordConfirmation { password }).isValid else {
                log.warning("Cannot register user! Validation failed!")
                state.dialog = Dialog(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
                return
            }

            log.debug("Send registration to backend")
            cancellableSet?.insert(
                AuthenticationService.shared.register(email: email, firstName: firstName, lastName: lastName, password: password)
                    .publisher
                    .sink(
                        receiveCompletion: { [weak self] completion in
                            if case let .failure(error) = completion {
                                log.error("User registration failed: \(error)")

                                if let errorResponse = error as? ErrorResponse, errorResponse.httpStatusCode == .conflict {
                                    log.debug("User already exists")
                                    self?.state.dialog = Dialog(title: R.string.localizable.error_title(),
                                                                message: R.string.localizable.error_message_registration_user_already_exists())
                                    return
                                }

                                self?.state.dialog = Dialog(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_failed())
                                return
                            }

                            log.debug("User registration successful")
                            let userInformation = UserDetailsView.UserInformation(firstName: firstName, lastName: lastName)
                            self?.navigator.toUserDetailsScreen(with: userInformation)
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

    static func createScreen(viewModel: RegistrationView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: RegistrationView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.defaultBackground()
        return screen
    }
}

struct PrivacyPolicyText: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<PrivacyPolicyText>) -> UITextView {
        let privacyPolicy = UITextView()
        privacyPolicy.backgroundColor = .clear
        privacyPolicy.textContainerInset = .zero
        privacyPolicy.textContainer.lineBreakMode = .byWordWrapping
        privacyPolicy.textContainer.heightTracksTextView = true
        return privacyPolicy
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<PrivacyPolicyText>) {
        let term = R.string.localizable.registration_term_privacy_policy()
        let formatted = R.string.localizable.registration_label_privacy_policy_agreement(term)
        uiView.attributedText = formatted.asLink(range: formatted.range(of: term), target: "https://www.nexd.app/privacy")
    }
}
