//
//  SceneDelegate.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import UIKit
import NexdClient

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var storage: Storage?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // Override point for customization after application launch.
        let propertyInjector = try? ComponentFactory.of(AppComponent.self).build(scene)
        propertyInjector?.injectProperties(into: self)

        NexdClientAPI.setup(authorizationToken: storage?.authorizationToken)

        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    /// Since we don't control creation of our AppDelegate, we have to use "property injection" to populate
    /// our required properties
    func injectProperties(_ window: UIWindow, storage: Storage) {
        self.window = window
        self.storage = storage
    }
}
