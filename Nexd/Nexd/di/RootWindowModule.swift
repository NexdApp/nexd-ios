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
            .to(factory: { (scene: UIScene, navigator: ScreenNavigating) -> UIWindow in
                guard let windowScene = scene as? UIWindowScene else {
                    fatalError("Missing scene!")
                }

                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = navigator.root
                return window
            })
    }
}
