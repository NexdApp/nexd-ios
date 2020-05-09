//
//  ViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

// import NexdClient
// import RxCocoa
// import RxSwift
// import SnapKit
// import UIKit

import Combine
import NexdClient
import SwiftUI

struct MainPageView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        GeometryReader { metrics in
            ZStack {
                // add white background of half screen height behind scrollview to avoid weird effects on overscroll
                R.color.defaultBackground.color
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(width: metrics.size.width, height: 0.5 * metrics.size.height)
                    .position(x: 0.5 * metrics.size.width, y: 0.75 * metrics.size.height)

                ScrollView {
                    VStack(spacing: 18) {
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
                                        .font(R.font.proximaNovaSoftBold.font(size: 65))
                                        .foregroundColor(R.color.headingText.color)
                                }
                                .padding(.top, -70)
                            }
                        )

                        Group {
                            Text(R.string.localizable.role_screen_title_ios(self.viewModel.state.displayName))
                                .fixedSize(horizontal: false, vertical: true)
                                .font(R.font.proximaNovaSoftBold.font(size: 48))
                                .foregroundColor(R.color.nexdGreen.color)

                            R.string.localizable.role_screen_subtitle.text
                                .fixedSize(horizontal: false, vertical: true)
                                .font(R.font.proximaNovaSoftBold.font(size: 35))
                                .foregroundColor(R.color.greetingSubline.color)

                            NexdUI.Buttons.lightMainMenuButton(text: R.string.localizable.role_selection_seeker.text) {
                                self.viewModel.seekerButtonTapped()
                            }

                            NexdUI.Buttons.lightMainMenuButton(text: R.string.localizable.role_selection_helper.text) {
                                self.viewModel.helperButtonTapped()
                            }
                            .padding(.bottom, 18)
                        }
                        .padding([.leading, .trailing], 25)
                    }
                    .background(R.color.defaultBackground.color)
                    .padding(.top, 115)
                }
//                .frame(height: metrics.size.height)
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
            let viewModel = MainPageView.ViewModel(navigator: PreviewNavigator(), authService: AuthenticationService(), userService: UserService())
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

// class MainPageViewController: ViewController<MainPageViewController.ViewModel> {
//    class ViewModel {
//        private let navigator: ScreenNavigating
//        private let userService: UserService
//        private let authService: AuthenticationService
//
//        private lazy var profile = userService.findMe()
//            .onApiErrors { [weak self] errorResponse in
//                log.error(errorResponse.httpStatusCode)
//
//                if errorResponse.httpStatusCode == .notFound || errorResponse.httpStatusCode == .unauthorized {
//                    self?.navigator.showError(title: R.string.localizable.error_dialog_authentication_failed_title(),
//                                              message: R.string.localizable.error_dialog_authentication_failed_message()) {
//                        self?.authService.logout()
//                        self?.navigator.toStartAuthenticationFlow()
//                    }
//                }
//            }
//            .asObservable()
//            .share(replay: 1)
//
//        lazy var profileButtonInitials: Driver<String?> = profile
//            .map { user in user.initials }
//            .asDriver(onErrorJustReturn: nil)
//
//        lazy var greeting: Driver<NSAttributedString?> = profile
//            .map { user in
//                R.string.localizable.role_screen_title_ios(user.firstName ?? user.lastName ?? "???")
//                    .asGreeting() + "\n" + R.string.localizable.role_screen_subtitle()
//                    .asGreetingSubline()
//            }
//            .asDriver(onErrorJustReturn: nil)
//
//        var profileButtonTaps: Binder<Void> {
//            Binder(self) { viewModel, _ in
//                viewModel.navigator.toProfileScreen()
//            }
//        }
//
//        let seekerButtonTitle = Driver.just(R.string.localizable.role_selection_seeker().asLightButtonText())
//
//        var seekerButtonTaps: Binder<Void> {
//            Binder(self) { viewModel, _ in
//                viewModel.navigator.toShoppingListOptions()
//            }
//        }
//
//        let helperButtonTitle = Driver.just(R.string.localizable.role_selection_helper().asLightButtonText())
//
//        var helperButtonTaps: Binder<Void> {
//            Binder(self) { viewModel, _ in
//                viewModel.navigator.toHelpOptions()
//            }
//        }
//
//        init(navigator: ScreenNavigating, userService: UserService, authenticationService: AuthenticationService) {
//            self.navigator = navigator
//            self.userService = userService
//            authService = authenticationService
//        }
//    }
//
//    enum Style {
//        static let profileImageSize = CGSize(width: 139, height: 139)
//        static let padding: CGFloat = 25
//
//        static let verticalPadding: CGFloat = 32
//        static let horizontalPadding: CGFloat = 8
//        static let buttonHeight: CGFloat = 132
//    }
//
//    private let bottomBackground = UIView()
//    private let headerBackground = UIView()
//    private let mainContent = UIView()
//    private let scrollView = UIScrollView()
//    private let userProfileButton = UIButton()
//    private let greetingText = UILabel()
//
//    private let seekerButton = MenuButton.make(style: .light)
//    private let helperButton = MenuButton.make(style: .light)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = R.color.nexdGreen()
//
//        bottomBackground.backgroundColor = .white
//        view.addSubview(bottomBackground)
//        bottomBackground.snp.makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//            make.height.equalToSuperview().dividedBy(2)
//        }
//
//        view.addSubview(scrollView)
//        scrollView.backgroundColor = .clear
//        scrollView.snp.makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//        }
//
//        scrollView.addSubview(mainContent)
//        mainContent.backgroundColor = R.color.defaultBackground()
//        mainContent.snp.makeConstraints { make in
//            make.bottom.equalToSuperview()
//            make.left.right.equalTo(view)
//            make.top.equalTo(scrollView).offset(115)
//        }
//
//        scrollView.addSubview(userProfileButton)
//        userProfileButton.backgroundColor = R.color.profileImageBackground()
//        userProfileButton.layer.cornerRadius = 0.5 * Style.profileImageSize.width
//        userProfileButton.setTitleColor(.white, for: .normal)
//        userProfileButton.titleLabel?.font = R.font.proximaNovaSoftBold(size: 65)
//        userProfileButton.snp.makeConstraints { make -> Void in
//            make.centerX.equalToSuperview()
//            make.centerY.equalTo(mainContent.snp.top)
//            make.size.equalTo(Style.profileImageSize)
//        }
//
//        mainContent.addSubview(greetingText)
//        greetingText.numberOfLines = 4
//        greetingText.snp.makeConstraints { make in
//            make.left.equalTo(mainContent).offset(Style.padding)
//            make.right.equalTo(mainContent).offset(-Style.padding)
//            make.top.equalTo(userProfileButton.snp.bottom).offset(27)
//            make.height.equalTo(200)
//        }
//
//        mainContent.addSubview(seekerButton)
//        seekerButton.snp.makeConstraints { make in
//            make.left.equalTo(mainContent).offset(Style.horizontalPadding)
//            make.right.equalTo(mainContent).offset(-Style.horizontalPadding)
//            make.top.equalTo(greetingText.snp.bottom).offset(Style.verticalPadding)
//            make.height.equalTo(132)
//        }
//
//        mainContent.addSubview(helperButton)
//        helperButton.snp.makeConstraints { make in
//            make.left.equalTo(mainContent).offset(Style.horizontalPadding)
//            make.right.equalTo(mainContent).offset(-Style.horizontalPadding)
//            make.top.equalTo(seekerButton.snp.bottom).offset(Style.verticalPadding)
//            make.height.equalTo(132)
//            make.bottom.equalToSuperview().offset(-Style.verticalPadding)
//        }
//    }
//
//    override func bind(viewModel: MainPageViewController.ViewModel, disposeBag: DisposeBag) {
//        disposeBag.insert(
//            viewModel.profileButtonInitials.drive(userProfileButton.rx.title()),
//            viewModel.greeting.drive(greetingText.rx.attributedText),
//            viewModel.helperButtonTitle.drive(helperButton.rx.attributedTitle(for: .normal)),
//            viewModel.seekerButtonTitle.drive(seekerButton.rx.attributedTitle(for: .normal)),
//
//            userProfileButton.rx.tap.bind(to: viewModel.profileButtonTaps),
//            seekerButton.rx.tap.bind(to: viewModel.seekerButtonTaps),
//            helperButton.rx.tap.bind(to: viewModel.helperButtonTaps)
//        )
//    }
// }

extension User {
    var initials: String {
        "\(firstName?.first?.description ?? "")\(lastName?.first?.description ?? "")"
    }

    var displayName: String {
        firstName ?? lastName ?? "???"
    }
}
