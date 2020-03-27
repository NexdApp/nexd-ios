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

    func updateUserInformation(usreId: Int, zipCode: String, firstName: String, lastName: String, phone: String) -> Single<User> {
        return UserAPI.userControllerUpdate(id: usreId,
                                            updateUserDto: UpdateUserDto(street: nil,
                                                                         number: nil,
                                                                         zipCode: zipCode,
                                                                         city: "",
                                                                         firstName: firstName,
                                                                         lastName: lastName,
                                                                         role: .helper,
                                                                         telephone: phone))
            .asSingle()
    }

    func fetchUserInfo(usreId: Int) -> Single<User> {
        return UserAPI.userControllerFindOne(id: usreId).asSingle()
    }
}
