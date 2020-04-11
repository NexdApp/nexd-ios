//
//  AppComponent.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse

struct AppComponent: Cleanse.RootComponent {
    typealias Root = PropertyInjector<SceneDelegate>
    typealias Scope = Singleton
    typealias Seed = UIScene

    static func configure(binder: Binder<Singleton>) {
        binder.include(module: CoreAppModule.self)
        binder.include(module: RootWindowModule.self)
    }

    static func configureRoot(binder bind: ReceiptBinder<PropertyInjector<SceneDelegate>>) -> BindingReceipt<PropertyInjector<SceneDelegate>> {
        bind.propertyInjector { bind -> BindingReceipt<PropertyInjector<SceneDelegate>> in
            bind.to(injector: SceneDelegate.injectProperties)
        }
    }
}
