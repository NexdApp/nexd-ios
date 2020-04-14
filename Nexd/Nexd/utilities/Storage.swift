//
//  Storage.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import Foundation
import NexdClient

protocol Storage {
    var authorizationToken: String? { get }
}

class PersistentStorage: Storage {
    static let shared = PersistentStorage(userDefaults: UserDefaults.standard)

    private let defaults: UserDefaults

    init(userDefaults: UserDefaults) {
        defaults = userDefaults
    }

    var authorizationToken: String? {
        get {
            defaults.string(forKey: "authorizationToken")
        }
        set(token) {
            defaults.setValue(token, forKey: "authorizationToken")
        }
    }
}
