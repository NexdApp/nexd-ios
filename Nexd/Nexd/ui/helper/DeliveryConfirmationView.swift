//
//  DeliveryConfirmationView.swift
//  nexd
//
//  Created by Tobias Schröpf on 13.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Rswift
import SwiftUI

struct DeliveryConfirmationView: View {
    struct ViewModel {
        let navigator: ScreenNavigating
        let helpList: HelpList
    }

    var viewModel: ViewModel

    var body: some View {
        return
            ScrollView {
                VStack(alignment: .leading) {
                    NexdUI.Headings.title(text: R.string.localizable.delivery_confirmation_screen_title.text)
                        .padding(.top, 109)
                        .padding([.leading, .trailing], 28)

                    ForEach(viewModel.helpList.helpRequests, id: \.id) { helpRequest in
                        VStack {
                            helpRequest.requester.map { requester in
                                NexdUI.Headings.h2Dark(text: Text(R.string.localizable.delivery_confirmation_section_header(requester.firstName)))
                                    .padding(.top, 26)
                                    .padding([.leading, .trailing], 28)
                            }

                            NexdUI.Card {
                                VStack {
                                    R.string.localizable.delivery_confirmation_phone_number_title.text
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(R.font.proximaNovaSoftRegular.font(size: 18))
                                        .foregroundColor(R.color.darkListItemTitle.color)

                                    helpRequest.phoneNumber.map { phone in
                                        Text(phone)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .font(R.font.proximaNovaSoftRegular.font(size: 20))
                                            .foregroundColor(R.color.nexdGreen.color)
                                    }

                                    Divider()

                                    R.string.localizable.delivery_confirmation_address_title.text
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(R.font.proximaNovaSoftRegular.font(size: 18))
                                        .foregroundColor(R.color.darkListItemTitle.color)

                                    helpRequest.zipCode.map { zipCode in
                                        Text(zipCode)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .font(R.font.proximaNovaSoftRegular.font(size: 20))
                                            .foregroundColor(R.color.nexdGreen.color)
                                    }
                                }
                            }
                            .padding([.leading, .trailing], 12)
                        }
                    }

                    NexdUI.Buttons.default(text: R.string.localizable.delivery_confirmation_confirm_button_title.text) {
                        log.debug("Implement me!")
                    }
                    .padding(.top, 46)
                    .padding(.bottom, 127)
                    .padding([.leading, .trailing], 28)
                }
                .background(R.color.nexdGreen.color)
            }
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
            let viewModel = DeliveryConfirmationView.ViewModel(navigator: PreviewNavigator(), helpList: HelpList.with())
            return Group {
                DeliveryConfirmationView(viewModel: viewModel)
                    .environment(\.locale, .init(identifier: "de"))

                DeliveryConfirmationView(viewModel: viewModel)
                    .environment(\.colorScheme, .light)
                    .environment(\.locale, .init(identifier: "en"))

                DeliveryConfirmationView(viewModel: viewModel)
                    .environment(\.colorScheme, .dark)
                    .environment(\.locale, .init(identifier: "en"))
            }
            .previewLayout(.sizeThatFits)
        }
    }

    extension HelpList {
        static func with(helpListId: Int = 0, requests: [[String]] = [["Apfel", "Birne", "Banane"], ["Bier", "Schnaps", "Wein"]]) -> HelpList {
            HelpList(id: Int64(helpListId),
                     helpRequestsIds: requests.enumerated().map { index, _ in Int64(index) },
                     ownerId: nil,
                     owner: nil,
                     createdAt: Date(),
                     updatedAt: Date(),
                     status: nil,
                     helpRequests: requests.enumerated().map { index, articles in HelpRequest.with(helpRequestId: index, requester: "Otto", articles: articles) })
        }
    }

    extension HelpRequest {
        static func with(helpRequestId: Int,
                         requester: String,
                         articles: [String],
                         street: String? = nil,
                         number: String? = nil,
                         zipCode: String? = nil,
                         city: String? = nil,
                         additionalRequest: String? = nil,
                         deliveryComment: String? = nil,
                         phoneNumber: String? = nil) -> HelpRequest {
            HelpRequest(street: street,
                        number: number,
                        zipCode: "84375",
                        city: "Kirchdorf am Inn",
                        id: Int64(helpRequestId),
                        helpListId: nil,
                        createdAt: nil,
                        priority: nil,
                        additionalRequest: additionalRequest,
                        deliveryComment: deliveryComment,
                        phoneNumber: "1234567890",
                        status: nil,
                        articles: articles.map { name in HelpRequestArticle.with(articleId: Int64(articles.lastIndex(of: name)!), name: name, count: 27) },
                        requesterId: nil,
                        requester: User(street: nil,
                                        number: nil,
                                        zipCode: nil,
                                        city: nil,
                                        id: "a",
                                        firstName: requester,
                                        lastName: requester,
                                        email: "nase",
                                        role: nil,
                                        phoneNumber: nil),
                        helpList: nil)
        }
    }

    extension HelpRequestArticle {
        static func with(articleId: Int64, name: String, count: Int64? = nil, done: Bool? = nil) -> HelpRequestArticle {
            HelpRequestArticle(id: articleId,
                               articleId: articleId,
                               articleCount: count,
                               article: Article(id: articleId, name: name),
                               articleDone: done,
                               helpRequest: nil)
        }
    }
#endif
