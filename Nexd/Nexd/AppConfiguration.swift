//
//  AppConfiguration.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Foundation

enum AppConfiguration {
    static var baseUrl: String? {
        return nil  // use default value from NexdAPI
//        return "http://localhost:3001"
//        return "http://nexd-api-alb-1107636132.eu-central-1.elb.amazonaws.com"
//        return "https://nexd-backend-staging.herokuapp.com:443/api/v1"
    }
}
