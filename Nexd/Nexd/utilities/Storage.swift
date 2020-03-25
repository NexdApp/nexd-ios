//
//  Storage.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation
import NexdClient

class Storage {
    static let shared = Storage()

    private let defaults = UserDefaults.standard

    var authorizationToken: String? {
        get {
            defaults.string(forKey: "authorizationToken")
        }
        set(email) {
            defaults.setValue(email, forKey: "authorizationToken")
        }
    }

    var userId: Int? {
        get {
            defaults.integer(forKey: "userId")
        }
        set(id) {
            defaults.setValue(id, forKey: "userId")
        }
    }
}
