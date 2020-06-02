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
    @Published var filteredHelpRequests: [HelpRequest]?
    @Published var units: [NexdClient.Unit]?

    var acceptedHelpRequests: [HelpRequest]? {
        guard let helpList = helpList, !helpList.helpRequests.isEmpty else {
            return nil
        }

        return helpList.helpRequests
    }

    var openHelpRequests: [HelpRequest]? {
        guard let filteredHelpRequests = filteredHelpRequests, !filteredHelpRequests.isEmpty else {
            return nil
        }

        return filteredHelpRequests
    }
}
