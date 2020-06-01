//
//  HelperWorkflowState.swift
//  nexd
//
//  Created by Tobias Schröpf on 01.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import SwiftUI

class HelperWorkflowState: ObservableObject {
    @Published var helpList: HelpList?
    @Published var helpRequests: [HelpRequest]?

    var acceptedHelpRequests: [HelpRequest]? {
        guard let helpList = helpList, !helpList.helpRequests.isEmpty else {
            return nil
        }

        return helpList.helpRequests
    }

    var openHelpRequests: [HelpRequest]? {
        guard let helpRequests = helpRequests, !helpRequests.isEmpty else {
            return nil
        }

        return helpRequests
    }
}
