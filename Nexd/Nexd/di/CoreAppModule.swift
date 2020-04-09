//
//  CoreAppModule.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse

struct CoreAppModule: Cleanse.Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: ServicesModule.self)

        binder
            .bind(UserDefaults.self)
            .to(value: UserDefaults.standard)

        binder
            .bind(Storage.self)
            .to(factory: PersistentStorage.init)

        binder
            .bind(ScreenNavigating.self)
            .to(factory: Navigator.init)
    }
}
