//
//  TransciptionState.swift
//  nexd
//
//  Created by Tobias Schröpf on 23.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import SwiftUI

class TranscribeViewState: ObservableObject {
    struct ListItem: Identifiable {
        let id: Int64
        let title: String
        let amount: Int64
    }

    var player: AudioPlayer?

    @Published var call: Call?

    @Published var isPlaying: Bool = false
    @Published var progress: Double = 0
    @Published var firstName: String?

    @Published var lastName: String?
    @Published var zipCode: String?
    @Published var city: String?
    @Published var street: String?
    @Published var streetNumber: String?
    @Published var phoneNumber: String?

    @Published var listItems: [ListItem] = []

    func createDto() -> HelpRequestCreateDto {
        HelpRequestCreateDto(firstName: firstName,
                             lastName: lastName,
                             street: street,
                             number: streetNumber,
                             zipCode: zipCode,
                             city: city,
                             articles: nil,
                             status: .pending,
                             additionalRequest: nil,
                             deliveryComment: nil,
                             phoneNumber: phoneNumber)
    }
}
