//
//  NexdUI+Modal.swift
//  nexd
//
//  Created by Tobias Schröpf on 30.05.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

extension View {
    func withModalButtons(cancelText: Text = R.string.localizable.cancel_button_title.text,
                          doneText: Text = R.string.localizable.done_button_title.text,
                          onCancel: @escaping (() -> Void),
                          onDone: @escaping (() -> Void)) -> some View {
        withCancelButton(text: cancelText, identifier: .modalCancelButton, action: onCancel)
            .withDoneButton(text: doneText, identifier: .modalDoneButton, action: onDone)
    }
}
