//
//  ShoppingListService.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import RxSwift
import SwaggerClient

class ShoppingListService {
    static let shared = ShoppingListService()

    func createShoppingList(requestIds: [Int]) -> Single<ShoppingList> {
        return ShoppingListAPI.shoppingListControllerInsertNewShoppingList(body: ShoppingListFormDto(requests: requestIds, status: nil))
            .asSingle()
    }

    func fetchShoppingLists() -> Single<[ShoppingList]> {
        return ShoppingListAPI.shoppingListControllerGetUserLists()
        .asSingle()
    }
}
