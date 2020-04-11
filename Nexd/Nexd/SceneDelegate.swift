//
//  SceneDelegate.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import NexdClient
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var storage: Storage?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        var propertyInjector: PropertyInjector<SceneDelegate>?

        do {
            let factory = try ComponentFactory.of(AppComponent.self)
            propertyInjector = factory.build(scene)
        } catch let error {
            fatalError("Dependency injection error: \(error)")
        }

        propertyInjector?.injectProperties(into: self)

        precondition(window != nil)
        precondition(storage != nil)

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
