//
//  KeyboardDismisser.swift
//  Nexd
//
//  Created by Tobias Schröpf on 01.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class KeyboardDismisser {
    lazy var tapper: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
    let rootView: UIView

    init(rootView: UIView) {
        self.rootView = rootView
        rootView.addGestureRecognizer(tapper)
    }

    deinit {
        rootView.removeGestureRecognizer(tapper)
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        rootView.endEditing(true)
    }
}
