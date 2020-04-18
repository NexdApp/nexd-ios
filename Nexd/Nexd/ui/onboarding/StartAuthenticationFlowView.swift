//
//  StartAuthenticationFlowView.swift
//  nexd
//
//  Created by Tobias Schröpf on 19.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct StartAuthenticationFlowView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        return ZStack {
            R.image.shopbag1.image
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading], 0)

            VStack {
                R.image.logo_white.image

                NexdUI.Buttons.lightButton(text: R.string.localizable.login_button_title_login.text) {
                    self.viewModel.onLoginTapped()
                }
                .padding(.top, 100)
                .padding([.leading, .trailing], 12)
                .frame(maxWidth: .infinity)

                NexdUI.Buttons.lightButton(text: R.string.localizable.login_button_title_register.text) {
                    self.viewModel.onRegisterTapped()
                }
                .padding([.leading, .trailing], 12)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

extension StartAuthenticationFlowView {
    class ViewModel: ObservableObject {
        private let navigator: ScreenNavigating

        init(navigator: ScreenNavigating) {
            self.navigator = navigator
        }

        func onLoginTapped() {
            navigator.toLoginScreen()
        }

        func onRegisterTapped() {
            navigator.toRegistrationScreen()
        }
    }

    static func createScreen(viewModel: StartAuthenticationFlowView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: StartAuthenticationFlowView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

#if DEBUG
    struct StartAuthenticationFlowView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = StartAuthenticationFlowView.ViewModel(navigator: PreviewNavigator())
            return Group {
                StartAuthenticationFlowView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                StartAuthenticationFlowView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                StartAuthenticationFlowView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
