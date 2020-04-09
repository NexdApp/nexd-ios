//
//  RootWindowModule.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse

struct RootWindowModule: Cleanse.Module {
    static func configure(binder: UnscopedBinder) {
        binder
            .bind()
            .to { (scene: UIScene, storage: Storage) -> UIWindow in
                guard let windowScene = scene as? UIWindowScene else {
                    fatalError()
                }

                let window = UIWindow(windowScene: windowScene)
                let rootVC = storage.authorizationToken == nil ? LoginViewController() : MainPageViewController()
                let navigationVC = UINavigationController(rootViewController: rootVC)
                window.rootViewController = navigationVC

                return window
            }
    }
}
