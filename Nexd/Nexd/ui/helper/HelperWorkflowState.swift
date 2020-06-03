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
    struct AmountItem: Identifiable, CustomStringConvertible {
        let amount: Int64
        let unit: NexdClient.Unit?

        var id: String {
            description
        }

        var description: String {
            guard let unitString = unit?.displayString(for: amount) else {
                return String(amount)
            }

            return "\(amount) \(unitString)"
        }
    }

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

    func amountItem(for article: HelpRequestArticle) -> HelperWorkflowState.AmountItem? {
        guard let articleCount = article.articleCount else {
            return nil
        }

        return HelperWorkflowState.AmountItem(amount: articleCount, unit: unit(for: article.unitId))
    }

    func unit(for unitId: Int64?) -> NexdClient.Unit? {
        guard let unitId = unitId else { return nil }

        return units?.first { $0.id == unitId }
    }
}
