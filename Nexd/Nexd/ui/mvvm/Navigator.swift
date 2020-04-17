//
//  Navigator.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import NexdClient
import SwiftUI
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
    func toRequestConfirmation(items: [RequestConfirmationViewController.Item])
    func toPhoneCall()
    func toHelpOptions()
    func toTranscribeInfoView()
    func toTranscribeListView()
    func toHelperOverview()
    func toCurrentItemsList(helpList: HelpList)
    func toCheckoutScreen(helpList: HelpList)
    func toDeliveryConfirmationScreen(helpList: HelpList)
}

class Navigator {
    private let storage: Storage
    private let authenticationService: AuthenticationService
    private let userService: UserService
    private let phoneService: PhoneService
    private let helpRequestsService: HelpRequestsService
    private let helpListsService: HelpListsService
    private let articlesService: ArticlesService

    lazy var navigationController: UINavigationController = {
        let loginPage = StartAuthenticationFlowViewController(viewModel: StartAuthenticationFlowViewController.ViewModel(navigator: self))
        let mainPage = MainPageViewController(viewModel: MainPageViewController.ViewModel(navigator: self, userService: userService, authenticationService: authenticationService))
        return UINavigationController(rootViewController: storage.authorizationToken == nil ? loginPage : mainPage)
    }()

    init(storage: Storage,
         authenticationService: AuthenticationService,
         userService: UserService,
         phoneService: PhoneService,
         helpRequestsService: HelpRequestsService,
         articlesService: ArticlesService,
         helpListsService: HelpListsService) {
        self.storage = storage
        self.authenticationService = authenticationService
        self.userService = userService
        self.phoneService = phoneService
        self.helpRequestsService = helpRequestsService
        self.helpListsService = helpListsService
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
        if let viewController = navigationController.presentedViewController {
            viewController.showSuccess(title: title, message: message, handler: handler)
            return
        }

        navigationController.topViewController?.showSuccess(title: title, message: message, handler: handler)
    }

    func showError(title: String, message: String, handler: (() -> Void)? = nil) {
        if let viewController = navigationController.presentedViewController {
            viewController.showError(title: title, message: message, handler: handler)
            return
        }

        navigationController.topViewController?.showError(title: title, message: message, handler: handler)
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
        guard let root = navigationController.viewControllers.first, root is MainPageViewController else {
            let mainScreen = MainPageViewController(viewModel: MainPageViewController.ViewModel(navigator: self,
                                                                                                userService: userService,
                                                                                                authenticationService: authenticationService))
            navigationController.setViewControllers([mainScreen], animated: true)
            return
        }

        navigationController.popToRootViewController(animated: true)
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
                                                                                                              articlesService: articlesService))
        push(screen: screen)
    }

    func toRequestConfirmation(items: [RequestConfirmationViewController.Item]) {
        let viewModel = RequestConfirmationViewController.ViewModel(navigator: self,
                                                                    requestService: helpRequestsService,
                                                                    items: items,
                                                                    onSuccess: { [weak self] in
                                                                        self?.showError(title: R.string.localizable.seeker_success_title(),
                                                                                        message: R.string.localizable.seeker_success_message(), handler: {
                                                                                            self?.navigationController.dismiss(animated: true) {
                                                                                                self?.goBack()
                                                                                            }
                                                                        })
                                                                    }, onError: { [weak self] _ in
                                                                        self?.showError(title: R.string.localizable.seeker_error_title(),
                                                                                        message: R.string.localizable.seeker_error_message(), handler: nil)
        })
        let screen = RequestConfirmationViewController(viewModel: viewModel)
        navigationController.present(screen, animated: true, completion: nil)
    }

    func toPhoneCall() {
        let screen = PhoneCallViewController(viewModel: PhoneCallViewController.ViewModel(phoneService: phoneService, navigator: self))
        push(screen: screen)
    }

    func toHelpOptions() {
        let screen = HelperOptionsViewController(viewModel: HelperOptionsViewController.ViewModel(navigator: self))
        push(screen: screen)
    }

    func toTranscribeInfoView() {
        push(screen: TranscribeInfoView.createScreen(viewModel: TranscribeInfoView.ViewModel(navigator: self, phoneService: phoneService)))
    }

    func toTranscribeListView() {
        push(screen: TranscribeListView.createScreen(viewModel: TranscribeListView.ViewModel(navigator: self, articlesService: articlesService)))
    }

    func toHelperOverview() {
        let screen = HelperRequestOverviewViewController(viewModel: HelperRequestOverviewViewController.ViewModel(navigator: self,
                                                                                                                  helpRequestsService: helpRequestsService,
                                                                                                                  helpListsService: helpListsService))
        push(screen: screen)
    }

    func toCurrentItemsList(helpList: HelpList) {
        let screen = ShoppingListViewController(viewModel: ShoppingListViewController.ViewModel(navigator: self, helpList: helpList))
        push(screen: screen)
    }

    func toCheckoutScreen(helpList: HelpList) {
        let screen = CheckoutViewController(viewModel: CheckoutViewController.ViewModel(navigator: self, helpList: helpList))
        push(screen: screen)
    }

    func toDeliveryConfirmationScreen(helpList: HelpList) {
        push(screen: DeliveryConfirmationView.createScreen(viewModel: DeliveryConfirmationView.ViewModel(navigator: self, helpList: helpList)))
    }

    private func push(screen: UIViewController) {
        navigationController.pushViewController(screen, animated: true)
    }
}
