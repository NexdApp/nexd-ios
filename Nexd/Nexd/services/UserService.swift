//
//  UserService.swift
//  Nexd
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient
import RxSwift

class UserService {
    static let shared = UserService()

    func updateUserInformation(firstName: String? = nil,
                               lastName: String? = nil,
                               street: String? = nil,
                               number: String? = nil,
                               zipCode: String? = nil,
                               city: String? = nil,
                               phoneNumber: String? = nil) -> Single<User> {
        let dto = UpdateUserDto(firstName: firstName, lastName: lastName, street: street, number: number, zipCode: zipCode, city: city, role: nil, phoneNumber: phoneNumber)
        return UsersAPI.userControllerUpdateMyself(updateUserDto: dto)
            .asSingle()
    }

    func fetchUserInfo(userId: String) -> Single<User> {
        return UsersAPI.userControllerFindOne(userId: userId).asSingle()
    }

    func findMe() -> Single<User> {
        return UsersAPI.userControllerFindMe()
            .asSingle()
    }
}
