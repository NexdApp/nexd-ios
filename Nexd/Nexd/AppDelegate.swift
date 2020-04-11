//
//  AppDelegate.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse
import UIKit
import XCGLogger

let log = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var factory: ComponentFactory<AppComponent>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Build our root object in our graph.
        factory = try? ComponentFactory.of(AppComponent.self)

        log.setup(level: .verbose, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, fileLevel: .debug)

        // You can also change the labels for each log level, most useful for alternate languages, French, German etc, but Emoji's are more fun
        log.levelDescriptions[.verbose] = "💜"
        log.levelDescriptions[.debug] = "💚"
        log.levelDescriptions[.info] = "💙"
        log.levelDescriptions[.notice] = "💛"
        log.levelDescriptions[.warning] = "🧡"
        log.levelDescriptions[.error] = "❤️"
        log.levelDescriptions[.severe] = "🖤"

        log.logAppDetails()

        return true
    }
}
