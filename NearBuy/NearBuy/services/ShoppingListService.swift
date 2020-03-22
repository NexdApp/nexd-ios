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

    func createShoppingList(requestIds: [Int]) -> Completable {
        return ShoppingListAPI.shoppingListControllerInsertNewShoppingList(body: ShoppingListFormDto(requests: requestIds, status: nil))
            .ignoreElements()
    }
}
