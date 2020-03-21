//
//  AppDelegate.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit
import XCGLogger
import SwaggerClient

let log = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

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

        SwaggerClientAPI.basePath = AppConfiguration.baseUrl
        AuthenticationAPI.authControllerLogin(body: LoginPayload(email: "test@test.de", password: "asdf")) { _, error in
            guard error == nil else {
                log.error("Error: \(error)")
                return
            }

            log.debug("JUHU")
        }

        return true
    }
}

