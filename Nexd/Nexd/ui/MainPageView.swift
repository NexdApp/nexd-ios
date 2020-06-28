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

struct MainPageView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        GeometryReader { metrics in
            ZStack(alignment: .bottom) {
                // add white background of half screen height behind scrollview to avoid weird effects on overscroll
                R.color.defaultBackground.color
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(width: metrics.size.width, height: metrics.size.height - 140)

                Button(
                    action: {
                        self.viewModel.profileButtonTapped()
                    },
                    label: {
                        ZStack(alignment: .center) {
                            Circle()
                                .fill(R.color.profileImageBackground.color)
                                .frame(width: 140, height: 140)

                            Text(self.viewModel.state.initials)
                                .font(R.font.proximaNovaBold.font(size: 65))
                                .foregroundColor(R.color.headingText.color)
                        }
                        .position(x: 0.5 * metrics.size.width, y: 140)
                    }
                )
                .identified(by: .mainPageProfileButton)

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Group {
                            Text(R.string.localizable.role_screen_title_format(self.viewModel.state.displayName.cstring))
                                .fixedSize(horizontal: false, vertical: true)
                                .font(R.font.proximaNovaBold.font(size: 48))
                                .foregroundColor(R.color.nexdGreen.color)

                            R.string.localizable.role_screen_subtitle.text
                                .fixedSize(horizontal: false, vertical: true)
                                .font(R.font.proximaNovaBold.font(size: 35))
                                .foregroundColor(R.color.greetingSubline.color)

                            NexdUI.Buttons.lightMainMenuButton(text: R.string.localizable.role_selection_seeker.text) {
                                self.viewModel.seekerButtonTapped()
                            }
                            .identified(by: .mainPageSeekerButton)

                            NexdUI.Buttons.lightMainMenuButton(text: R.string.localizable.role_selection_helper.text) {
                                self.viewModel.helperButtonTapped()
                            }
                            .padding(.bottom, 18)
                            .identified(by: .mainPageHelperButton)
                        }
                        .padding([.leading, .trailing], 25)
                    }
                }
                .frame(height: metrics.size.height  - 210)
            }
            .onAppear { self.viewModel.bind() }
            .onDisappear { self.viewModel.unbind() }
        }
    }
}

extension MainPageView {
    class ViewModel: ObservableObject {
        class ViewState: ObservableObject {
            @Published var initials: String = ""
            @Published var displayName: String = "-"
        }

        private let navigator: ScreenNavigating
        private let authService: AuthenticationService
        private let userService: UserService
        private var cancellableSet: Set<AnyCancellable>?

        var state = ViewState()

        init(navigator: ScreenNavigating, authService: AuthenticationService, userService: UserService) {
            self.navigator = navigator
            self.authService = authService
            self.userService = userService
        }

        func profileButtonTapped() {
            navigator.toProfileScreen()
        }

        func seekerButtonTapped() {
            navigator.toShoppingListOptions()
        }

        func helperButtonTapped() {
            navigator.toHelpOptions()
        }

        func bind() {
            var cancellableSet = Set<AnyCancellable>()

            cancellableSet.insert(
                userService.findMe()
                    .onApiErrors { [weak self] errorResponse in
                        log.error(errorResponse.httpStatusCode)

                        if errorResponse.httpStatusCode == .notFound || errorResponse.httpStatusCode == .unauthorized {
                            self?.navigator.showError(title: R.string.localizable.error_dialog_authentication_failed_title(),
                                                      message: R.string.localizable.error_dialog_authentication_failed_message()) {
                                self?.authService.logout()
                                self?.navigator.toStartAuthenticationFlow()
                            }
                        } else {
                            self?.navigator.showError(title: R.string.localizable.error_dialog_backend_communication_failed_title(),
                                                      message: R.string.localizable.error_dialog_backend_communication_failed_message()) {
                                self?.navigator.showErrorOverlay()
                            }
                        }
                    }
                    .publisher
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else {
                            return
                        }

                        log.error("Creating help request failed: \(error)")
                    }, receiveValue: { [weak self] user in
                        self?.state.initials = user.initials
                        self?.state.displayName = user.displayName
                    })
            )

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

    static func createScreen(viewModel: MainPageView.ViewModel) -> UIViewController {
        let screen = UIHostingController(rootView: MainPageView(viewModel: viewModel))
        screen.view.backgroundColor = R.color.nexdGreen()
        return screen
    }
}

#if DEBUG
    struct MainPageView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = MainPageView.ViewModel(navigator: PreviewNavigator(),
                                                   authService: AuthenticationService(storage: PersistentStorage(userDefaults: UserDefaults.standard)),
                                                   userService: UserService())
            return Group {
                MainPageView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.locale, .init(identifier: "de"))

                MainPageView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                MainPageView(viewModel: viewModel)
                    .background(R.color.nexdGreen.color)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
