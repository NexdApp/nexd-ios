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
    let helpRequestCreationState: HelpRequestCreationState = HelpRequestCreationState()
    var player: AudioPlayer?

    @Published var call: Call?

    @Published var isPlaying: Bool = false
    @Published var progress: Double = 0
}
