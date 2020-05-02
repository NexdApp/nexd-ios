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

    func toRequestConfirmation(items: [RequestConfirmationView.Item]) {
        log.debug("toRequestConfirmation - items: \(items)")
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

    func toTranscribeListView(player: AudioPlayer?, call: Call?, transcribedRequest: HelpRequestCreateDto) {
        log.debug("toTranscribeListView")
    }

    func toTranscribeEndView() {
        log.debug("toTranscribeEndView")
    }

    func toHelperOverview() {
        log.debug("toHelperOverview")
    }

    func addingHelperRequest(request: HelpRequest, to helpList: HelpList) -> Single<HelpList> {
        log.debug("toRequestDetails")
        return Single.never()
    }

    func removingHelperRequest(request: HelpRequest, to helpList: HelpList) -> Single<HelpList> {
        log.debug("removingHelperRequest")
        return Single.never()
    }

    func changingHelperRequestFilterSettings(zipCode: String?) -> Single<HelperRequestFilterSettingsView.Result?> {
        log.debug("changingHelperRequestFilterSettings")
        return Single.never()
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
                           article: Article(id: articleId, name: name, language: .deDe, categoryId: nil, status: nil, unitIdOrder: nil, category: nil),
                           unit: nil,
                           articleDone: nil,
                           helpRequest: nil)
    }
}
