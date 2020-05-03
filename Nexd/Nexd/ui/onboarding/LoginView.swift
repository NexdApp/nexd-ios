//
//  LoginView.swift
//  nexd
//
//  Created by Julian Manke on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import RxSwift
import SnapKit
import SwiftUI
import UIKit

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
                log.debug("ZEFIX - implement me!")
            }
            .padding([.bottom, .leading, .trailing], 12)
        }
        .keyboardAdaptive()
        .dismissingKeyboard()
    }
}

extension LoginView {
    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var username: String?
            @Published var password: String?
        }

        private let navigator: ScreenNavigating

        var state = ViewState()

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
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

//
// extension LoginViewController {
//    @objc func loginButtonPressed(sender: UIButton!) {
//        let hasInvalidInput = [email, password]
//            .map { $0.validate() }
//            .contains(false)
//
//        guard !hasInvalidInput else {
//            log.warning("Cannot login user! Validation failed!")
//            showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_registration_validation_failed())
//            return
//        }
//
//        guard let email = email.value, let password = password.value else {
//            log.warning("Missing mandatory login information!")
//            return
//        }
//
//        AuthenticationService.shared.login(email: email, password: password)
//            .subscribe(onCompleted: { [weak self] in
//                log.debug("Login successful!")
//                self?.viewModel?.navigator.toMainScreen()
//            }, onError: { [weak self] error in
//                log.error("Login failed: \(error)")
//                self?.showError(title: R.string.localizable.error_title(), message: R.string.localizable.error_message_login_failed())
//            })
//            .disposed(by: disposeBag)
//    }
//
//    @objc func registerButtonPressed(sender: UIButton!) {
//        viewModel?.navigator.toRegistrationScreen()
//    }
// }
