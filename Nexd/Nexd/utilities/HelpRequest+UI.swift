//
//  HelpList+UI.swift
//  nexd
//
//  Created by Tobias Schröpf on 18.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient

extension HelpRequest {
    var displayName: String {
        guard let firstName = firstName else { return R.string.localizable.helper_request_overview_unknown_requester() }

        return firstName.isEmpty ? R.string.localizable.helper_request_overview_unknown_requester() : firstName
    }
}
