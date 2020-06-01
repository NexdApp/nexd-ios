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

    var acceptedHelpRequests: [AcceptedRequestCell.Item]? {
        return nil
    }

    var openHelpRequests: [AcceptedRequestCell.Item]? {
        return nil
    }
}
