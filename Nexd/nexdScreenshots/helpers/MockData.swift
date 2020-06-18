//
//  NexdClient+Mock.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 15.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient

enum MockData {
    static var shared: MockDataProtocol = LocalizedMockData()
}

protocol MockDataProtocol {
    var users: [NexdClient.User] { get }
    var articles: [NexdClient.Article] { get }
    var units: [NexdClient.Unit] { get }
    var helpRequests: [NexdClient.HelpRequest] { get }
    var helpLists: [NexdClient.HelpList] { get }
}

struct LocalizedMockData: MockDataProtocol {
    let users: [NexdClient.User] = [
        NexdClient.User(firstName: "user_firstname".localized(),
                        lastName: "user_lastname".localized(),
                        street: nil,
                        number: nil,
                        zipCode: "user_zipcode".localized(),
                        city: nil,
                        id: "",
                        email: nil,
                        role: nil,
                        phoneNumber: nil)
    ]

    let articles: [NexdClient.Article] = [
        NexdClient.Article(id: 0,
                           name: "article_name_suggestion_1".localized(),
                           language: .current,
                           statusOverwritten: nil,
                           popularity: 0,
                           unitIdOrder: [2],
                           categoryId: nil,
                           status: nil,
                           category: nil),
        NexdClient.Article(id: 1,
                           name: "article_name_suggestion_2".localized(),
                           language: .current,
                           statusOverwritten: nil,
                           popularity: 1,
                           unitIdOrder: nil,
                           categoryId: nil,
                           status: nil,
                           category: nil),
        NexdClient.Article(id: 2,
                           name: "article_name_suggestion_3".localized(),
                           language: .current,
                           statusOverwritten: nil,
                           popularity: 2,
                           unitIdOrder: nil,
                           categoryId: nil,
                           status: nil,
                           category: nil),
        NexdClient.Article(id: 3,
                           name: "article_name_suggestion_4".localized(),
                           language: .current,
                           statusOverwritten: nil,
                           popularity: 3,
                           unitIdOrder: nil,
                           categoryId: nil,
                           status: nil,
                           category: nil),
        NexdClient.Article(id: 4,
                           name: "article_name_suggestion_5".localized(),
                           language: .current,
                           statusOverwritten: nil,
                           popularity: 4,
                           unitIdOrder: nil,
                           categoryId: nil,
                           status: nil,
                           category: nil)
    ]

    let units: [NexdClient.Unit] = [
        NexdClient.Unit(id: 0,
                        nameShort: "unit_short_gram".localized(),
                        language: .current,
                        defaultOrder: nil,
                        nameZero: "unit_name_gram".localized(),
                        nameOne: "unit_name_gram".localized(),
                        nameTwo: "unit_name_gram".localized(),
                        nameFew: "unit_name_gram".localized(),
                        nameMany: "unit_name_gram".localized(),
                        nameOther: "unit_name_gram".localized()),
        NexdClient.Unit(id: 1,
                        nameShort: "unit_short_kilogram".localized(),
                        language: .current,
                        defaultOrder: nil,
                        nameZero: "unit_name_kilogram".localized(),
                        nameOne: "unit_name_kilogram".localized(),
                        nameTwo: "unit_name_kilogram".localized(),
                        nameFew: "unit_name_kilogram".localized(),
                        nameMany: "unit_name_kilogram".localized(),
                        nameOther: "unit_name_kilogram".localized()),
        NexdClient.Unit(id: 2,
                        nameShort: "unit_short_piece".localized(),
                        language: .current,
                        defaultOrder: nil,
                        nameZero: "unit_name_piece".localized(),
                        nameOne: "unit_name_piece".localized(),
                        nameTwo: "unit_name_piece".localized(),
                        nameFew: "unit_name_piece".localized(),
                        nameMany: "unit_name_piece".localized(),
                        nameOther: "unit_name_piece".localized()),
        NexdClient.Unit(id: 3,
                        nameShort: "unit_short_package".localized(),
                        language: .current,
                        defaultOrder: nil,
                        nameZero: "unit_name_package".localized(),
                        nameOne: "unit_name_package".localized(),
                        nameTwo: "unit_name_package".localized(),
                        nameFew: "unit_name_package".localized(),
                        nameMany: "unit_name_package".localized(),
                        nameOther: "unit_name_package".localized()),
        NexdClient.Unit(id: 4,
                        nameShort: "unit_short_bottle".localized(),
                        language: .current,
                        defaultOrder: nil,
                        nameZero: "unit_name_bottle".localized(),
                        nameOne: "unit_name_bottle".localized(),
                        nameTwo: "unit_name_bottle".localized(),
                        nameFew: "unit_name_bottle".localized(),
                        nameMany: "unit_name_bottle".localized(),
                        nameOther: "unit_name_bottle".localized()),
        NexdClient.Unit(id: 5,
                        nameShort: "unit_short_liter".localized(),
                        language: .current,
                        defaultOrder: nil,
                        nameZero: "unit_name_liter".localized(),
                        nameOne: "unit_name_liter".localized(),
                        nameTwo: "unit_name_liter".localized(),
                        nameFew: "unit_name_liter".localized(),
                        nameMany: "unit_name_liter".localized(),
                        nameOther: "unit_name_liter".localized())
    ]

    let helpRequests: [HelpRequest] = [
        HelpRequest.mock(firstName: "open_help_request_1_firstname".localized(), id: 0, createdAt: Date(timeIntervalSinceNow: -600.0)),
        HelpRequest.mock(firstName: "open_help_request_2_firstname".localized(), id: 1, createdAt: Date(timeIntervalSinceNow: -700.0), callSid: "abc "),
        HelpRequest.mock(firstName: "open_help_request_3_firstname".localized(), id: 2, createdAt: Date(timeIntervalSinceNow: -800.0)),
        HelpRequest.mock(firstName: "open_help_request_4_firstname".localized(), id: 3, createdAt: Date(timeIntervalSinceNow: -900.0)),
        HelpRequest.mock(firstName: "open_help_request_5_firstname".localized(), id: 4, createdAt: Date(timeIntervalSinceNow: -10000.0))
    ]

    var helpLists: [HelpList] = [
        HelpList.mock(id: 0,
                      status: .active,
                      helpRequests: [
                          HelpRequest.mock(firstName: "accepted_help_request_1_firstname".localized(),
                                           lastName: "accepted_help_request_1_lastname".localized(),
                                           street: "accepted_help_request_1_street".localized(),
                                           number: "accepted_help_request_1_number".localized(),
                                           zipCode: "accepted_help_request_1_zipcode".localized(),
                                           city: "accepted_help_request_1_city".localized(),
                                           id: 0,
                                           createdAt: Date(timeIntervalSinceNow: -100.0),
                                           additionalRequest: "accepted_help_request_1_additional_request".localized(),
                                           deliveryComment: "accepted_help_request_1_delivery_comment".localized(),
                                           phoneNumber: "accepted_help_request_1_phonenumber".localized(),
                                           articles: [
                                               HelpRequestArticle.from(article: Article.mock(id: 0, name: "article_name_banana".localized(), unitIdOrder: [0]), amount: 500),
                                               HelpRequestArticle.from(article: Article.mock(id: 1, name: "article_name_milk".localized(), unitIdOrder: [5]), amount: 3)
                                           ]),
                          HelpRequest.mock(firstName: "accepted_help_request_2_firstname".localized(),
                                           lastName: "accepted_help_request_2_lastname".localized(),
                                           street: "accepted_help_request_2_street".localized(),
                                           number: "accepted_help_request_2_number".localized(),
                                           zipCode: "accepted_help_request_2_zipcode".localized(),
                                           city: "accepted_help_request_2_city".localized(),
                                           id: 1,
                                           createdAt: Date(timeIntervalSinceNow: -200.0),
                                           additionalRequest: "accepted_help_request_2_additional_request".localized(),
                                           deliveryComment: "accepted_help_request_2_delivery_comment".localized(),
                                           phoneNumber: "accepted_help_request_2_phonenumber".localized(),
                                           articles: [
                                               HelpRequestArticle.from(article: Article.mock(id: 0, name: "article_name_coffee".localized(), unitIdOrder: [3]), amount: 1),
                                               HelpRequestArticle.from(article: Article.mock(id: 1, name: "article_name_water".localized(), unitIdOrder: [4]), amount: 6)
                                           ])
                      ])
    ]
}

extension HelpRequest {
    static func mock(firstName: String? = nil,
                     lastName: String? = nil,
                     street: String? = nil,
                     number: String? = nil,
                     zipCode: String? = nil,
                     city: String? = nil,
                     id: Int64? = nil,
                     helpListId: Int64? = nil,
                     createdAt: Date? = nil,
                     priority: String? = nil,
                     additionalRequest: String? = nil,
                     deliveryComment: String? = nil,
                     phoneNumber: String? = nil,
                     status: Status? = nil,
                     articles: [HelpRequestArticle]? = nil,
                     requesterId: String? = nil,
                     requester: User? = nil,
                     helpList: HelpList? = nil,
                     callSid: String? = nil) -> HelpRequest {
        HelpRequest(firstName: firstName,
                    lastName: lastName,
                    street: street,
                    number: number,
                    zipCode: zipCode,
                    city: city,
                    id: id,
                    helpListId: helpListId,
                    createdAt: createdAt,
                    priority: priority,
                    additionalRequest: additionalRequest,
                    deliveryComment: deliveryComment,
                    phoneNumber: phoneNumber,
                    status: status,
                    articles: articles,
                    requesterId: requesterId,
                    requester: requester,
                    helpList: helpList,
                    callSid: callSid)
    }
}

extension HelpList {
    static func mock(id: Int64,
                     helpRequestsIds: [Int64] = [],
                     ownerId: String? = nil,
                     owner: User? = nil,
                     createdAt: Date = Date(),
                     updatedAt: Date = Date(),
                     status: Status? = nil,
                     helpRequests: [HelpRequest]) -> HelpList {
        HelpList(id: id,
                 helpRequestsIds: helpRequestsIds,
                 ownerId: ownerId,
                 owner: owner,
                 createdAt: createdAt,
                 updatedAt: updatedAt,
                 status: status,
                 helpRequests: helpRequests)
    }
}

extension HelpRequestArticle {
    static func mock(id: Int64? = nil,
                     articleId: Int64? = nil,
                     unitId: Int64? = nil,
                     articleCount: Int64? = nil,
                     article: Article? = nil,
                     unit: Unit? = nil,
                     articleDone: Bool? = nil,
                     helpRequest: HelpRequest? = nil) -> HelpRequestArticle {
        HelpRequestArticle(id: id,
                           articleId: articleId,
                           unitId: unitId,
                           articleCount: articleCount,
                           article: article,
                           unit: unit,
                           articleDone: articleDone,
                           helpRequest: helpRequest)
    }

    static func from(article: Article, amount: Int64) -> HelpRequestArticle {
        HelpRequestArticle(id: article.id,
                           articleId: article.id,
                           unitId: article.unitIdOrder?.first,
                           articleCount: amount,
                           article: article,
                           unit: nil,
                           articleDone: nil,
                           helpRequest: nil)
    }
}

extension Article {
    static func mock(id: Int64,
                     name: String,
                     language: AvailableLanguages = .current,
                     statusOverwritten: Bool? = nil,
                     popularity: Int64 = 0,
                     unitIdOrder: [Int64]? = nil,
                     categoryId: Int64? = nil,
                     status: Status? = nil,
                     category: Category? = nil) -> Article {
        Article(id: id,
                name: name,
                language: language,
                statusOverwritten: statusOverwritten,
                popularity: popularity,
                unitIdOrder: unitIdOrder,
                categoryId: categoryId,
                status: status,
                category: category)
    }
}

extension AvailableLanguages {
    static var current: AvailableLanguages {
        guard let language = deviceLanguage.parseLanguage() else {
            return .en
        }

        return AvailableLanguages(rawValue: language) ?? .en
    }
}
