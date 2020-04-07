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

    func updateUserInformation(zipCode: String, firstName: String, lastName: String, phone: String) -> Single<User> {
        let dto = UpdateUserDto(street: nil, number: nil, zipCode: zipCode, city: nil, firstName: firstName, lastName: lastName, role: nil, telephone: phone)
        return UsersAPI.userControllerUpdateMyself(updateUserDto: dto)
            .asSingle()
    }

    func fetchUserInfo(userId: String) -> Single<User> {
        return UsersAPI.userControllerFindOne(userId: userId).asSingle()
    }

    func findMe() -> Single<User> {
        return UsersAPI.userControllerFindMe().asSingle()
    }
}
