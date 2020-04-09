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
    func toLoginScreen()
    func toRegistrationScreen()
    func toUserDetailsScreen(with userInformation: UserDetailsViewController.UserInformation)
    func toMainScreen()
    func toShoppingListOptions()
}

class Navigator {
    private let storage: Storage

    lazy var navigationController: UINavigationController = {
        let loginPage = LoginViewController(viewModel: LoginViewController.ViewModel(navigator: self))
        let mainPage = MainPageViewController(viewModel: MainPageViewModel(navigator: self))
        return UINavigationController(rootViewController: storage.authorizationToken == nil ? loginPage : mainPage)
    }()

    init(storage: Storage) {
        self.storage = storage
    }
}

extension Navigator: ScreenNavigating {
    var root: UIViewController {
        navigationController
    }

    func toLoginScreen() {
        guard let index = navigationController.viewControllers.firstIndex(where: { $0 is LoginViewController }) else {
            navigationController.setViewControllers([LoginViewController(viewModel: LoginViewController.ViewModel(navigator: self))], animated: true)
            return
        }

        navigationController.popToViewController(navigationController.viewControllers[index], animated: true)
    }

    func toRegistrationScreen() {
        let registrationScreen = RegistrationViewController(viewModel: RegistrationViewController.ViewModel(navigator: self))
        navigationController.pushViewController(registrationScreen, animated: true)
    }

    func toUserDetailsScreen(with userInformation: UserDetailsViewController.UserInformation) {
        let userDetailsScreen = UserDetailsViewController(viewModel: UserDetailsViewController.ViewModel(navigator: self, userInformation: userInformation))
        navigationController.pushViewController(userDetailsScreen, animated: true)
    }

    func toMainScreen() {
        let mainScreen = MainPageViewController(viewModel: MainPageViewModel(navigator: self))
        navigationController.setViewControllers([mainScreen], animated: true)
    }

    func toShoppingListOptions() {}
}
