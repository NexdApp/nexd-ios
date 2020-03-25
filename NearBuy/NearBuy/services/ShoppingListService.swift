//
//  ShoppingListService.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import RxSwift
import NexdClient

class ShoppingListService {
    static let shared = ShoppingListService()

    func createShoppingList(requestIds: [Int]) -> Single<ShoppingList> {
        // FIXME: remove -1 once swagger api is fixed
        return ShoppingListAPI.shoppingListControllerInsertNewShoppingList(shoppingListFormDto: ShoppingListFormDto(requests: requestIds.first ?? -1, status: nil))
            .asSingle()
    }

    func fetchShoppingLists() -> Single<[ShoppingList]> {
        return ShoppingListAPI.shoppingListControllerGetUserLists()
        .asSingle()
    }
}
