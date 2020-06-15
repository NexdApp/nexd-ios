//
//  NexdClient+Mock.swift
//  nexdScreenshots
//
//  Created by Tobias Schröpf on 15.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient

enum MockData {
    static var shared: MockDataProtocol {
        switch deviceLanguage.prefix(2) {
        case "de":
            return GermanMockData.shared
        case "en":
            return EnglishMockData.shared
        default:
            return GermanMockData.shared
        }
    }
}

protocol MockDataProtocol {
    var users: [NexdClient.User] { get }
    var articles: [NexdClient.Article] { get }
    var units: [NexdClient.Unit] { get }
    var helpRequests: [NexdClient.HelpRequest] { get }
    var helpLists: [NexdClient.HelpList] { get }
}

struct GermanMockData: MockDataProtocol {
    static let shared = GermanMockData()

    let users: [NexdClient.User] = [
        NexdClient.User(firstName: "Maria", lastName: "Schultz", street: nil, number: nil, zipCode: "34032", city: nil, id: "", email: nil, role: nil, phoneNumber: nil)
    ]

    let articles: [NexdClient.Article] = [
        NexdClient.Article(id: 0, name: "Apfel", language: .de, statusOverwritten: nil, popularity: 0, unitIdOrder: [2], categoryId: nil, status: nil, category: nil),
        NexdClient.Article(id: 3, name: "Apfelmuss", language: .de, statusOverwritten: nil, popularity: 1, unitIdOrder: [3], categoryId: nil, status: nil, category: nil),
        NexdClient.Article(id: 4, name: "Apfelsaft", language: .de, statusOverwritten: nil, popularity: 2, unitIdOrder: [4, 5], categoryId: nil, status: nil, category: nil),
        NexdClient.Article(id: 5, name: "Apfelringe", language: .de, statusOverwritten: nil, popularity: 3, unitIdOrder: [3], categoryId: nil, status: nil, category: nil)
    ]

    let units: [NexdClient.Unit] = [
        NexdClient.Unit(id: 0, nameShort: "kg", language: .de, defaultOrder: nil, nameZero: "Kilogramm", nameOne: "Kilogramm", nameTwo: "Kilogramm", nameFew: "Kilogramm", nameMany: "Kilogramm", nameOther: "Kilogramm"),
        NexdClient.Unit(id: 1, nameShort: "g", language: .de, defaultOrder: nil, nameZero: "Gramm", nameOne: "Gramm", nameTwo: "Gramm", nameFew: "Gramm", nameMany: "Gramm", nameOther: "Gramm"),
        NexdClient.Unit(id: 2, nameShort: "Stk.", language: .de, defaultOrder: nil, nameZero: "Stück", nameOne: "Stück", nameTwo: "Stück", nameFew: "Stück", nameMany: "Stück", nameOther: "Stück"),
        NexdClient.Unit(id: 3, nameShort: "Pkg.", language: .de, defaultOrder: nil, nameZero: "Packung", nameOne: "Packung", nameTwo: "Packung", nameFew: "Packung", nameMany: "Packung", nameOther: "Packung"),
        NexdClient.Unit(id: 4, nameShort: "Fl.", language: .de, defaultOrder: nil, nameZero: "Flasche", nameOne: "Flasche", nameTwo: "Flasche", nameFew: "Flasche", nameMany: "Flasche", nameOther: "Flasche"),
        NexdClient.Unit(id: 5, nameShort: "l", language: .de, defaultOrder: nil, nameZero: "Liter", nameOne: "Liter", nameTwo: "Liter", nameFew: "Liter", nameMany: "Liter", nameOther: "Liter")
    ]

    let helpRequests: [HelpRequest] = [
        HelpRequest.mock(firstName: "Stephanie", id: 0, createdAt: Date.init(timeIntervalSinceNow: -600.0)),
        HelpRequest.mock(firstName: "Erik", id: 1, createdAt: Date.init(timeIntervalSinceNow: -700.0)),
        HelpRequest.mock(firstName: "Gabriele", id: 2, createdAt: Date.init(timeIntervalSinceNow: -800.0)),
        HelpRequest.mock(firstName: "Christina", id: 3, createdAt: Date.init(timeIntervalSinceNow: -900.0)),
        HelpRequest.mock(firstName: "Niklas", id: 4, createdAt: Date.init(timeIntervalSinceNow: -10000.0))
    ]

    let helpLists: [HelpList] = [
        HelpList.mock(id: 0,
                      status: .active,
                      helpRequests: [
                        HelpRequest.mock(firstName: "Leon", id: 0, createdAt: Date.init(timeIntervalSinceNow: -100.0)),
                        HelpRequest.mock(firstName: "Ute", id: 1, createdAt: Date.init(timeIntervalSinceNow: -200.0))
        ])
    ]
}

struct EnglishMockData: MockDataProtocol {
    static let shared = EnglishMockData()

    let users: [NexdClient.User] = [
        NexdClient.User(firstName: "Maria", lastName: "Schultz", street: nil, number: nil, zipCode: "34032", city: nil, id: "", email: nil, role: nil, phoneNumber: nil)
    ]

    let articles: [NexdClient.Article] = [
        NexdClient.Article(id: 0, name: "Apple", language: .en, statusOverwritten: nil, popularity: 0, unitIdOrder: [2], categoryId: nil, status: nil, category: nil),
        NexdClient.Article(id: 1, name: "Apple juice", language: .en, statusOverwritten: nil, popularity: 1, unitIdOrder: [4, 5], categoryId: nil, status: nil, category: nil),
        NexdClient.Article(id: 1, name: "Apple pie", language: .en, statusOverwritten: nil, popularity: 2, unitIdOrder: [2], categoryId: nil, status: nil, category: nil)
    ]

    let units: [NexdClient.Unit] = [
        NexdClient.Unit(id: 0, nameShort: "kg", language: .en, defaultOrder: nil, nameZero: "kilogram", nameOne: "kilogram", nameTwo: "kilogram", nameFew: "kilogram", nameMany: "kilogram", nameOther: "kilogram"),
        NexdClient.Unit(id: 1, nameShort: "gr.", language: .en, defaultOrder: nil, nameZero: "grams", nameOne: "grams", nameTwo: "grams", nameFew: "grams", nameMany: "grams", nameOther: "grams"),
        NexdClient.Unit(id: 2, nameShort: "pc.", language: .en, defaultOrder: nil, nameZero: "piece", nameOne: "piece", nameTwo: "piece", nameFew: "piece", nameMany: "piece", nameOther: "piece"),
        NexdClient.Unit(id: 3, nameShort: "pack.", language: .en, defaultOrder: nil, nameZero: "package", nameOne: "package", nameTwo: "package", nameFew: "package", nameMany: "package", nameOther: "package"),
        NexdClient.Unit(id: 3, nameShort: "pack.", language: .en, defaultOrder: nil, nameZero: "package", nameOne: "package", nameTwo: "package", nameFew: "package", nameMany: "package", nameOther: "package")
    ]

    let helpRequests: [HelpRequest] = [
        HelpRequest.mock(firstName: "Heather", id: 0, createdAt: Date.init(timeIntervalSinceNow: -600.0)),
        HelpRequest.mock(firstName: "Daniel", id: 1, createdAt: Date.init(timeIntervalSinceNow: -700.0)),
        HelpRequest.mock(firstName: "Teresa", id: 2, createdAt: Date.init(timeIntervalSinceNow: -800.0)),
        HelpRequest.mock(firstName: "Betty", id: 3, createdAt: Date.init(timeIntervalSinceNow: -900.0)),
        HelpRequest.mock(firstName: "James", id: 4, createdAt: Date.init(timeIntervalSinceNow: -10000.0))
    ]

    let helpLists: [HelpList] = [
        HelpList.mock(id: 0,
                      status: .active,
                      helpRequests: [
                        HelpRequest.mock(firstName: "Samuel", id: 0, createdAt: Date.init(timeIntervalSinceNow: -100.0)),
                        HelpRequest.mock(firstName: "Barbara", id: 1, createdAt: Date.init(timeIntervalSinceNow: -200.0))
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
