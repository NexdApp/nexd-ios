//
//  Navigator.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import UIKit

protocol ScreenNavigating {
    var root: UIViewController { get }
    func goBack()
    func showSuccess(title: String, message: String, handler: (() -> Void)?)
    func showError(title: String, message: String, handler: (() -> Void)?)

    func toStartAuthenticationFlow()
    func toLoginScreen()
    func toRegistrationScreen()
    func toUserDetailsScreen(with userInformation: UserDetailsViewController.UserInformation)
    func toMainScreen()
    func toProfileScreen()
    func toShoppingListOptions()
    func toCheckList()
    func toPhoneCall()
    func toHelpOptions()
}

class Navigator {
    private let storage: Storage
    private let userService: UserService
    private let callsService: CallsService
    private let requestService: RequestService
    private let articlesService: ArticlesService

    lazy var navigationController: UINavigationController = {
        let loginPage = StartAuthenticationFlowViewController(viewModel: StartAuthenticationFlowViewController.ViewModel(navigator: self))
        let mainPage = MainPageViewController(viewModel: MainPageViewController.ViewModel(navigator: self, userService: userService))
        return UINavigationController(rootViewController: storage.authorizationToken == nil ? loginPage : mainPage)
    }()

    init(storage: Storage, userService: UserService, callsService: CallsService, requestService: RequestService, articlesService: ArticlesService) {
        self.storage = storage
        self.userService = userService
        self.callsService = callsService
        self.requestService = requestService
        self.articlesService = articlesService
    }
}

extension Navigator: ScreenNavigating {
    var root: UIViewController {
        navigationController
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }

    func showSuccess(title: String, message: String, handler: (() -> Void)?) {
        navigationController.showSuccess(title: title, message: title, handler: handler)
    }

    func showError(title: String, message: String, handler: (() -> Void)?) {
        navigationController.showError(title: title, message: title, handler: handler)
    }

    func toStartAuthenticationFlow() {
        guard let index = navigationController.viewControllers.firstIndex(where: { $0 is StartAuthenticationFlowViewController }) else {
            navigationController.setViewControllers([StartAuthenticationFlowViewController(viewModel: StartAuthenticationFlowViewController.ViewModel(navigator: self))],
                                                    animated: true)
            return
        }

        navigationController.popToViewController(navigationController.viewControllers[index], animated: true)
    }

    func toLoginScreen() {
        let screen = LoginViewController(viewModel: LoginViewController.ViewModel(navigator: self))
        push(screen: screen)
    }

    func toRegistrationScreen() {
        let screen = RegistrationViewController(viewModel: RegistrationViewController.ViewModel(navigator: self))
        push(screen: screen)
    }

    func toUserDetailsScreen(with userInformation: UserDetailsViewController.UserInformation) {
        let screen = UserDetailsViewController(viewModel: UserDetailsViewController.ViewModel(navigator: self, userInformation: userInformation))
        push(screen: screen)
    }

    func toMainScreen() {
        let mainScreen = MainPageViewController(viewModel: MainPageViewController.ViewModel(navigator: self, userService: userService))
        navigationController.setViewControllers([mainScreen], animated: true)
    }

    func toProfileScreen() {
        let profileScreen = UserProfileViewController()
        profileScreen.onUserLoggedOut = { [weak self] in
            log.debug("User logged out!")
            self?.navigationController.dismiss(animated: true) { [weak self] in
                self?.toStartAuthenticationFlow()
            }
        }

        navigationController.present(profileScreen, animated: true, completion: nil)
    }

    func toShoppingListOptions() {
        let screen = ShoppingListOptionViewController(viewModel: ShoppingListOptionViewController.ViewModel(navigator: self))
        push(screen: screen)
    }

    func toCheckList() {
        let screen = SeekerItemSelectionViewController(viewModel: SeekerItemSelectionViewController.ViewModel(navigator: self,
                                                                                                              articlesService: articlesService,
                                                                                                              requestService: requestService))
        push(screen: screen)
    }

    func toPhoneCall() {
        let screen = PhoneCallViewController(viewModel: PhoneCallViewController.ViewModel(callsService: callsService, navigator: self))
        push(screen: screen)
    }

    func toHelpOptions() {
        let screen = HelperRequestOverviewViewController()
        push(screen: screen)
    }

    private func push(screen: UIViewController) {
        navigationController.pushViewController(screen, animated: true)
    }
}
