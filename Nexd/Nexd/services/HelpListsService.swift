//
//  ShoppingListService.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient
import RxSwift

class HelpListsService {
    func createShoppingList(requestIds: [Int64]) -> Single<HelpList> {
        let dto = HelpListCreateDto(helpRequestsIds: requestIds, status: .active)
        return HelpListsAPI.helpListsControllerInsertNewHelpList(helpListCreateDto: dto)
            .asSingle()
    }

    func addRequest(withId helpRequestId: Int64, to helpListId: Int64) -> Single<HelpList> {
        return HelpListsAPI.helpListsControllerAddHelpRequestToList(helpListId: helpListId, helpRequestId: helpRequestId)
            .asSingle()
    }

    func removeRequest(withId helpRequestId: Int64, from helpListId: Int64) -> Single<HelpList> {
        return HelpListsAPI.helpListsControllerDeleteHelpRequestFromHelpList(helpListId: helpListId, helpRequestId: helpRequestId)
            .asSingle()
    }

    func fetchHelpList(helpListId: Int64) -> Single<HelpList> {
        return HelpListsAPI.helpListsControllerFindOne(helpListId: helpListId)
            .asSingle()
    }

    func fetchShoppingLists() -> Single<[HelpList]> {
        return HelpListsAPI.helpListsControllerGetUserLists()
            .asSingle()
    }

    func activeHelpList() -> Single<HelpList> {
        fetchShoppingLists()
            .flatMap { existingLists -> Single<HelpList> in
                if let existingList = existingLists.filter({ $0.status == .active }).first {
                    return Single.just(existingList)
                }

                return self.createShoppingList(requestIds: [])
            }
    }

    func completeHelpList(helpListId: Int64, helpRequestsIds: [Int64]?) -> Single<HelpList> {
        let dto = HelpListCreateDto(helpRequestsIds: helpRequestsIds, status: .completed)
        return HelpListsAPI.helpListsControllerUpdateHelpLists(helpListId: helpListId, helpListCreateDto: dto)
            .asSingle()
    }
}
