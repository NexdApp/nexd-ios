//
//  ViewControllersModule.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse

struct ViewControllersModule: Cleanse.Module {
    static func configure(binder: Binder<Singleton>) {
        binder.include(module: MainPageViewController.Module.self)
    }
}
