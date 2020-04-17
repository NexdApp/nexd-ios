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

    func updateUserInformation(zipCode: String, phone: String) -> Single<User> {
        let dto = UpdateUserDto(firstName: nil, lastName: nil, street: nil, number: nil, zipCode: zipCode, city: nil, role: nil, phoneNumber: phone)
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
