//
//  ModalScreen.swift
//  nexd
//
//  Created by Tobias Schröpf on 26.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import SwiftUI

class ModalScreen<Content: View>: UIHostingController<Content> {
    var onDismiss: (() -> Void)?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
        }
    }
}
