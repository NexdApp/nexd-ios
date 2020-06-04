//
//  Navigator.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import NexdClient
import RxSwift
import SwiftUI
import UIKit

protocol ScreenNavigating {
    var root: UIViewController { get }
    func goBack()
    func showSuccess(title: String, message: String, handler: (() -> Void)?)
    func showError(title: String, message: String, handler: (() -> Void)?)
    func showErrorOverlay()

    func toStartAuthenticationFlow()
    func toLoginScreen()
    func toRegistrationScreen()
    func toUserDetailsScreen(with userInformation: UserDetailsView.UserInformation)
    func toMainScreen()
    func toProfileScreen()
    func toShoppingListOptions()
    func toCreateShoppingList()
    func toArticleInput(helpRequestCreationState: HelpRequestCreationState,
                        with item: HelpRequestCreationState.Item?,
                        onItemSaved: @escaping ((HelpRequestCreationState.Item) -> Void))
    func toRequestConfirmation(state: HelpRequestCreationState)
    func toPhoneCall()
    func toHelpOptions()
    func toTranscribeInfoView()
    func toTranscribeListView(state: TranscribeViewState)
    func toTranscribeEndView()
    func toHelperOverview()
    func addingHelperRequest(request: HelpRequest, in state: HelperWorkflowState, onFinished: @escaping (HelperWorkflowState) -> Void)
    func removingHelperRequest(request: HelpRequest, in state: HelperWorkflowState, onFinished: @escaping (HelperWorkflowState) -> Void)
    func changingHelperRequestFilterSettings(zipCode: String?, onFilterChanged: ((HelperRequestFilterSettingsView.Result?) -> Void)?)
    func toShoppingList(helperWorkflowState: HelperWorkflowState)
    func toCheckoutScreen(helperWorkflowState: HelperWorkflowState)
    func toDeliveryConfirmationScreen(helperWorkflowState: HelperWorkflowState)
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
        let loginPage = StartAuthenticationFlowView.createScreen(viewModel: StartAuthenticationFlowView.ViewModel(navigator: self))
        let mainPage = MainPageView.createScreen(viewModel: MainPageView.ViewModel(navigator: self, authService: authenticationService, userService: userService))

        let controller = UINavigationController(rootViewController: storage.authorizationToken == nil ? loginPage : mainPage)
        controller.navigationBar.isHidden = true
        return controller
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

    func showErrorOverlay() {
        let screen = ErrorOverlay.createScreen(viewModel: ErrorOverlay.ViewModel(navigator: self, userService: userService, onErrorVanished: { [weak self] in self?.dismiss() }))
        screen.modalPresentationStyle = .fullScreen
        present(screen: screen)
    }

    func toStartAuthenticationFlow() {
        guard let index = navigationController.viewControllers.firstIndex(where: { ($0 is UIHostingController<StartAuthenticationFlowView>) }) else {
            navigationController.setViewControllers([StartAuthenticationFlowView.createScreen(viewModel: StartAuthenticationFlowView.ViewModel(navigator: self))],
                                                    animated: true)
            return
        }

        navigationController.popToViewController(navigationController.viewControllers[index], animated: true)
    }

    func toLoginScreen() {
        let screen = LoginView.createScreen(viewModel: LoginView.ViewModel(navigator: self, authenticationService: authenticationService))
        push(screen: screen)
    }

    func toRegistrationScreen() {
        let screen = RegistrationView.createScreen(viewModel: RegistrationView.ViewModel(navigator: self, authenticationService: authenticationService))
        push(screen: screen)
    }

    func toUserDetailsScreen(with userInformation: UserDetailsView.UserInformation) {
        let screen = UserDetailsView.createScreen(viewModel: UserDetailsView.ViewModel(navigator: self, userService: userService, userInformation: userInformation))
        push(screen: screen)
    }

    func toMainScreen() {
        let mainScreen = MainPageView.createScreen(viewModel: MainPageView.ViewModel(navigator: self, authService: authenticationService, userService: userService))
        navigationController.setViewControllers([mainScreen], animated: true)
    }

    func toProfileScreen() {
        let screen = UserProfileView.createScreen(viewModel: UserProfileView.ViewModel(navigator: self,
                                                                                       authenticationService: authenticationService,
                                                                                       userService: userService,
                                                                                       onFinished: { [weak self] didLogout in
                                                                                           self?.dismiss { [weak self] in
                                                                                               if didLogout {
                                                                                                   log.debug("User logged out!")
                                                                                                   self?.toStartAuthenticationFlow()
                                                                                               }
                                                                                           }
        }))

        present(screen: screen)
    }

    func toShoppingListOptions() {
        let screen = ShoppingListOptionView.createScreen(viewModel: ShoppingListOptionView.ViewModel(navigator: self))
        push(screen: screen)
    }

    func toCreateShoppingList() {
        let screen = SeekerItemSelectionView.createScreen(viewModel: SeekerItemSelectionView.ViewModel(navigator: self,
                                                                                                       articlesService: articlesService))
        push(screen: screen)
    }

    func toArticleInput(helpRequestCreationState: HelpRequestCreationState,
                        with item: HelpRequestCreationState.Item?,
                        onItemSaved: @escaping ((HelpRequestCreationState.Item) -> Void)) {
        let screen = SeekerArticleInputView.createScreen(viewModel: SeekerArticleInputView.ViewModel(navigator: self,
                                                                                                     articlesService: articlesService,
                                                                                                     itemSelectionViewState: helpRequestCreationState,
                                                                                                     item: item,
                                                                                                     onDone: { [weak self] item in
                                                                                                         onItemSaved(item)
                                                                                                         self?.dismiss()
                                                                                                     },
                                                                                                     onCancel: { [weak self] in self?.dismiss() }))

        present(screen: screen)
    }

    func toRequestConfirmation(state: HelpRequestCreationState) {
        let viewModel = RequestConfirmationView.ViewModel(navigator: self,
                                                          userService: userService,
                                                          helpRequestsService: helpRequestsService,
                                                          state: state,
                                                          onSuccess: { [weak self] in
                                                              self?.showError(title: R.string.localizable.seeker_success_title(),
                                                                              message: R.string.localizable.seeker_success_message(), handler: {
                                                                                  self?.navigationController.dismiss(animated: true) {
                                                                                      self?.goBack()
                                                                                  }
                                                              })
                                                          },
                                                          onError: { [weak self] _ in
                                                              self?.showError(title: R.string.localizable.seeker_error_title(),
                                                                              message: R.string.localizable.seeker_error_message(), handler: nil)
        })
        let screen = RequestConfirmationView.createScreen(viewModel: viewModel)
        present(screen: screen)
    }

    func toPhoneCall() {
        log.debug("Implement ME!")
    }

    func toHelpOptions() {
        let screen = HelperOptionsView.createScreen(viewModel: HelperOptionsView.ViewModel(navigator: self))
        push(screen: screen)
    }

    func toTranscribeInfoView() {
        push(screen: TranscribeInfoView.createScreen(viewModel: TranscribeInfoView.ViewModel(navigator: self, phoneService: phoneService)))
    }

    func toTranscribeListView(state: TranscribeViewState) {
        push(screen: TranscribeListView.createScreen(viewModel: TranscribeListView.ViewModel(navigator: self,
                                                                                             articlesService: articlesService,
                                                                                             phoneService: phoneService,
                                                                                             state: state)))
    }

    func toTranscribeEndView() {
        push(screen: TranscribeEndView.createScreen(viewModel: TranscribeEndView.ViewModel(navigator: self)))
    }

    func toHelperOverview() {
        let screen = HelperRequestOverviewView.createScreen(viewModel: HelperRequestOverviewView.ViewModel(navigator: self,
                                                                                                           userService: userService,
                                                                                                           helpRequestsService: helpRequestsService,
                                                                                                           helpListsService: helpListsService,
                                                                                                           articlesService: articlesService))
        push(screen: screen)
    }

    func addingHelperRequest(request: HelpRequest, in state: HelperWorkflowState, onFinished: @escaping (HelperWorkflowState) -> Void) {
        let screen = RequestDetailsView.createScreen(viewModel: RequestDetailsView.ViewModel(type: .addRequestToHelpList,
                                                                                             navigator: self,
                                                                                             helpListService: helpListsService,
                                                                                             helpRequest: request,
                                                                                             helperWorkflowState: state,
                                                                                             onFinished: { [weak self] helpList in
                                                                                                 state.helpList = helpList
                                                                                                 self?.dismiss {
                                                                                                     onFinished(state)
                                                                                                 }
                                                                                             }, onCancelled: { [weak self] in
                                                                                                 self?.dismiss {
                                                                                                     onFinished(state)
                                                                                                 }
        }))
        present(screen: screen)
    }

    func removingHelperRequest(request: HelpRequest, in state: HelperWorkflowState, onFinished: @escaping (HelperWorkflowState) -> Void) {
        let screen = RequestDetailsView.createScreen(viewModel: RequestDetailsView.ViewModel(type: .removeRequestFromHelpList,
                                                                                             navigator: self,
                                                                                             helpListService: helpListsService,
                                                                                             helpRequest: request,
                                                                                             helperWorkflowState: state,
                                                                                             onFinished: { [weak self] helpList in
                                                                                                 state.helpList = helpList
                                                                                                 self?.dismiss {
                                                                                                     onFinished(state)
                                                                                                 }
                                                                                             }, onCancelled: { [weak self] in
                                                                                                 self?.dismiss {
                                                                                                     onFinished(state)
                                                                                                 }
        }))
        present(screen: screen)
    }

    func changingHelperRequestFilterSettings(zipCode: String?, onFilterChanged: ((HelperRequestFilterSettingsView.Result?) -> Void)?) {
        let screen = HelperRequestFilterSettingsView.createScreen(viewModel: HelperRequestFilterSettingsView.ViewModel(navigator: self,
                                                                                                                       zipCode: zipCode,
                                                                                                                       onCancelled: { [weak self] in
                                                                                                                           self?.dismiss(completion: nil)
                                                                                                                       },
                                                                                                                       onFinished: { [weak self] result in
                                                                                                                           onFilterChanged?(result)
                                                                                                                           self?.dismiss(completion: nil)
        }))
        present(screen: screen)
    }

    func toShoppingList(helperWorkflowState: HelperWorkflowState) {
        let screen = ShoppingListView.createScreen(viewModel: ShoppingListView.ViewModel(navigator: self, helperWorkflowState: helperWorkflowState))
        push(screen: screen)
    }

    func toCheckoutScreen(helperWorkflowState: HelperWorkflowState) {
        let screen = CheckoutView.createScreen(viewModel: CheckoutView.ViewModel(navigator: self, helperWorkflowState: helperWorkflowState))
        push(screen: screen)
    }

    func toDeliveryConfirmationScreen(helperWorkflowState: HelperWorkflowState) {
        push(screen: DeliveryConfirmationView.createScreen(viewModel: DeliveryConfirmationView.ViewModel(navigator: self,
                                                                                                         helperWorkflowState: helperWorkflowState,
                                                                                                         helpListsService: helpListsService)))
    }

    private func push(screen: UIViewController) {
        navigationController.pushViewController(screen, animated: true)
    }

    private func present(screen: UIViewController) {
        navigationController.present(screen, animated: true, completion: nil)
    }

    private func dismiss(completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: true, completion: completion)
    }
}
