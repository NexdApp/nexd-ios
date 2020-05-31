//
//  NexdUI+Modal.swift
//  nexd
//
//  Created by Tobias Schröpf on 30.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

extension View {
    func withModalButtons(onCancel: @escaping (() -> Void), onDone: @escaping (() -> Void)) -> some View {
        withCancelButton(identifier: .modalCancelButton, action: onCancel)
            .withDoneButton(identifier: .modalDoneButton, action: onDone)
    }
}
