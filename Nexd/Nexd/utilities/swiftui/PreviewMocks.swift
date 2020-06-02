//
//  PreviewMocks.swift
//  nexd
//
//  Created by Tobias Schröpf on 14.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient
import RxSwift

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

    func toUserDetailsScreen(with userInformation: UserDetailsView.UserInformation) {
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

    func toCreateShoppingList() {
        log.debug("toCreateShoppingList")
    }

    func toArticleInput(helpRequestCreationState: HelpRequestCreationState,
                        with item: HelpRequestCreationState.Item?,
                        onItemSaved: (HelpRequestCreationState.Item) -> Void) {
        log.debug("toArticleInput")
    }

    func toRequestConfirmation(state: HelpRequestCreationState) {
        log.debug("toRequestConfirmation - items: \(state)")
    }

    func toPhoneCall() {
        log.debug("toPhoneCall")
    }

    func toHelpOptions() {
        log.debug("toHelpOptions")
    }

    func toTranscribeInfoView() {
        log.debug("toTranscribeInfoView")
    }

    func toTranscribeListView(state: TranscribeViewState) {
        log.debug("toTranscribeListView")
    }

    func toTranscribeEndView() {
        log.debug("toTranscribeEndView")
    }

    func toHelperOverview() {
        log.debug("toHelperOverview")
    }

    func addingHelperRequest(request: HelpRequest, in state: HelperWorkflowState, onFinished: @escaping (HelperWorkflowState) -> Void) {
        log.debug("toRequestDetails")
    }

    func removingHelperRequest(request: HelpRequest, in state: HelperWorkflowState, onFinished: @escaping (HelperWorkflowState) -> Void) {
        log.debug("removingHelperRequest")
    }

    func changingHelperRequestFilterSettings(zipCode: String?, onFilterChanged: ((HelperRequestFilterSettingsView.Result?) -> Void)?) {
        log.debug("changingHelperRequestFilterSettings")
    }

    func toShoppingList(helpList: HelpList) {
        log.debug("toShoppingList - helpList: \(helpList)")
    }

    func toCheckoutScreen(helpList: HelpList) {
        log.debug("toCheckoutScreen - helpList: \(helpList)")
    }

    func toDeliveryConfirmationScreen(helpList: HelpList) {
        log.debug("toDeliveryConfirmationScreen - helpList: \(helpList)")
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
        HelpRequest(firstName: nil,
                    lastName: nil,
                    street: nil,
                    number: nil,
                    zipCode: nil,
                    city: nil,
                    id: nil,
                    helpListId: nil,
                    createdAt: nil,
                    priority: nil,
                    additionalRequest: nil,
                    deliveryComment: nil,
                    phoneNumber: nil,
                    status: nil,
                    articles: nil,
                    requesterId: nil,
                    requester: nil,
                    helpList: nil,
                    callSid: nil)
    }
}

extension HelpRequestArticle {
    static func with(articleId: Int64, name: String, count: Int64? = nil, done: Bool? = nil) -> HelpRequestArticle {
        HelpRequestArticle(id: articleId,
                           articleId: articleId,
                           unitId: nil,
                           articleCount: nil,
                           article: Article(id: articleId,
                                            name: name,
                                            language: .de,
                                            statusOverwritten: nil,
                                            popularity: 0,
                                            unitIdOrder: nil,
                                            categoryId: nil,
                                            status: nil,
                                            category: nil),
                           unit: nil,
                           articleDone: nil,
                           helpRequest: nil)
    }
}
