//
//  ViewController.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import RxCocoa
import RxSwift
import SnapKit
import UIKit

extension User {
    var initials: String {
        "\(firstName?.first?.description ?? "")\(lastName?.first?.description ?? "")"
    }
}

class MainPageViewController: ViewController<MainPageViewController.ViewModel> {
    class ViewModel {
        private let navigator: ScreenNavigating
        private let userService: UserService
        private let authService: AuthenticationService

        private lazy var profile = userService.findMe()
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
            .asObservable()
            .share(replay: 1)

        lazy var profileButtonInitials: Driver<String?> = profile
            .map { user in user.initials }
            .asDriver(onErrorJustReturn: nil)

        lazy var greeting: Driver<NSAttributedString?> = profile
            .map { user in
                R.string.localizable.role_screen_title_ios(user.firstName ?? user.lastName ?? "???")
                    .asGreeting() + "\n" + R.string.localizable.role_screen_subtitle()
                    .asGreetingSubline()
            }
            .asDriver(onErrorJustReturn: nil)

        var profileButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.toProfileScreen()
            }
        }

        let seekerButtonTitle = Driver.just(R.string.localizable.role_selection_seeker().asLightButtonText())

        var seekerButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.toShoppingListOptions()
            }
        }

        let helperButtonTitle = Driver.just(R.string.localizable.role_selection_helper().asLightButtonText())

        var helperButtonTaps: Binder<Void> {
            Binder(self) { viewModel, _ in
                viewModel.navigator.toHelpOptions()
            }
        }

        init(navigator: ScreenNavigating, userService: UserService, authenticationService: AuthenticationService) {
            self.navigator = navigator
            self.userService = userService
            authService = authenticationService
        }
    }

    enum Style {
        static let profileImageSize = CGSize(width: 139, height: 139)
        static let padding: CGFloat = 25

        static let verticalPadding: CGFloat = 32
        static let horizontalPadding: CGFloat = 8
        static let buttonHeight: CGFloat = 132
    }

    private let bottomBackground = UIView()
    private let headerBackground = UIView()
    private let mainContent = UIView()
    private let scrollView = UIScrollView()
    private let userProfileButton = UIButton()
    private let greetingText = UILabel()

    private let seekerButton = MenuButton.make(style: .light)
    private let helperButton = MenuButton.make(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.nexdGreen()
        navigationController?.navigationBar.isHidden = true

        bottomBackground.backgroundColor = .white
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }

        view.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        scrollView.addSubview(mainContent)
        mainContent.backgroundColor = R.color.defaultBackground()
        mainContent.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalTo(view)
            make.top.equalTo(scrollView).offset(115)
        }

        scrollView.addSubview(userProfileButton)
        userProfileButton.backgroundColor = R.color.profileImageBackground()
        userProfileButton.layer.cornerRadius = 0.5 * Style.profileImageSize.width
        userProfileButton.setTitleColor(.white, for: .normal)
        userProfileButton.titleLabel?.font = R.font.proximaNovaSoftBold(size: 65)
        userProfileButton.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(mainContent.snp.top)
            make.size.equalTo(Style.profileImageSize)
        }

        mainContent.addSubview(greetingText)
        greetingText.numberOfLines = 4
        greetingText.snp.makeConstraints { make in
            make.left.equalTo(mainContent).offset(Style.padding)
            make.right.equalTo(mainContent).offset(-Style.padding)
            make.top.equalTo(userProfileButton.snp.bottom).offset(27)
            make.height.equalTo(200)
        }

        mainContent.addSubview(seekerButton)
        seekerButton.snp.makeConstraints { make in
            make.left.equalTo(mainContent).offset(Style.horizontalPadding)
            make.right.equalTo(mainContent).offset(-Style.horizontalPadding)
            make.top.equalTo(greetingText.snp.bottom).offset(Style.verticalPadding)
            make.height.equalTo(132)
        }

        mainContent.addSubview(helperButton)
        helperButton.snp.makeConstraints { make in
            make.left.equalTo(mainContent).offset(Style.horizontalPadding)
            make.right.equalTo(mainContent).offset(-Style.horizontalPadding)
            make.top.equalTo(seekerButton.snp.bottom).offset(Style.verticalPadding)
            make.height.equalTo(132)
            make.bottom.equalToSuperview().offset(-Style.verticalPadding)
        }
    }

    override func bind(viewModel: MainPageViewController.ViewModel, disposeBag: DisposeBag) {
        disposeBag.insert(
            viewModel.profileButtonInitials.drive(userProfileButton.rx.title()),
            viewModel.greeting.drive(greetingText.rx.attributedText),
            viewModel.helperButtonTitle.drive(helperButton.rx.attributedTitle(for: .normal)),
            viewModel.seekerButtonTitle.drive(seekerButton.rx.attributedTitle(for: .normal)),

            userProfileButton.rx.tap.bind(to: viewModel.profileButtonTaps),
            seekerButton.rx.tap.bind(to: viewModel.seekerButtonTaps),
            helperButton.rx.tap.bind(to: viewModel.helperButtonTaps)
        )
    }
}
