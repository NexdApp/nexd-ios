//
//  Storage.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import SwaggerClient

class Storage {
    static let shared = Storage()

    private let defaults = UserDefaults.standard

    var loggedInUserEmail: String? {
        get {
            defaults.string(forKey: "loggedInUserEmail")
        }
        set(email) {
            defaults.setValue(email, forKey: "loggedInUserEmail")
        }
    }
}
