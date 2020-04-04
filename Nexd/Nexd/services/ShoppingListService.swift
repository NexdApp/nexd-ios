//
//  ShoppingListService.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import RxSwift
import NexdClient

class ShoppingListService {
    static let shared = ShoppingListService()

    func createShoppingList(requestIds: [Int]) -> Single<HelpList> {
        let dto = HelpListCreateDto(helpRequestsIds: requestIds, status: .active)
        return HelpListsAPI.helpListsControllerInsertNewHelpList(helpListCreateDto: dto)
            .asSingle()
    }

    func fetchShoppingLists() -> Single<[HelpList]> {
        return HelpListsAPI.helpListsControllerGetUserLists()
        .asSingle()
    }
}
