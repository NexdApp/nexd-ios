//
//  DeliveryConfirmationView.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

struct DeliveryConfirmationView: View {
    struct ViewModel {
        let navigator: ScreenNavigating
    }

    var viewModel: ViewModel

    var body: some View {
        return
            VStack {
                Text("Hello World")
            }
            .background(R.color.nexdGreen.swiftui())
    }
}

#if DEBUG
    import NexdClient
    class PreviewNavigator: ScreenNavigating {
        var root: UIViewController = UIViewController()

        func goBack() {
            log.debug("goBack")
        }

        func showSuccess(title: String, message: String, handler: (() -> Void)?) {
            log.debug("showSuccess - title: \(title) - message: \(message)")
        }

        func showError(title: String, message: String, handler: (() -> Void)?) {
            log.debug("showError - title: \(title) - message: \(message)")
        }

        func toStartAuthenticationFlow() {
            log.debug("toStartAuthenticationFlow")
        }

        func toLoginScreen() {
            log.debug("toLoginScreen")
        }

        func toRegistrationScreen() {
            log.debug("toRegistrationScreen")
        }

        func toUserDetailsScreen(with userInformation: UserDetailsViewController.UserInformation) {
            log.debug("toUserDetailsScreen - userInformation: \(userInformation)")
        }

        func toMainScreen() {
            log.debug("toMainScreen")
        }

        func toProfileScreen() {
            log.debug("toProfileScreen")
        }

        func toShoppingListOptions() {
            log.debug("toShoppingListOptions")
        }

        func toCheckList() {
            log.debug("toCheckList")
        }

        func toRequestConfirmation(items: [RequestConfirmationViewController.Item]) {
            log.debug("toRequestConfirmation - items: \(items)")
        }

        func toPhoneCall() {
            log.debug("toPhoneCall")
        }

        func toHelpOptions() {
            log.debug("toHelpOptions")
        }

        func toCallsList() {
            log.debug("toCallsList")
        }

        func toTranscribeCall() {
            log.debug("toTranscribeCall")
        }

        func toHelperOverview() {
            log.debug("toHelperOverview")
        }

        func toCurrentItemsList(helpList: HelpList) {
            log.debug("toCurrentItemsList - helpList: \(helpList)")
        }

        func toCheckoutScreen(helpList: HelpList) {
            log.debug("toCheckoutScreen - helpList: \(helpList)")
        }

        func toDeliveryConfirmationScreen(helpList: HelpList) {
            log.debug("toDeliveryConfirmationScreen - helpList: \(helpList)")
        }
    }

    struct DeliveryConfirmationView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                DeliveryConfirmationView(viewModel: DeliveryConfirmationView.ViewModel(navigator: PreviewNavigator()))
                    .environment(\.colorScheme, .light)

                DeliveryConfirmationView(viewModel: DeliveryConfirmationView.ViewModel(navigator: PreviewNavigator()))
                    .environment(\.colorScheme, .dark)
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
