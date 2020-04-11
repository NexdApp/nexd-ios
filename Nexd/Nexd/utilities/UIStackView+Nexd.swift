//
//  UIStackView+Nexd.swift
//  nexd
//
//  Created by Tobias Schröpf on 11.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UIStackView {
    func asCard() {
        let subView = UIView(frame: bounds)
        subView.layer.cornerRadius = 10
        subView.backgroundColor = R.color.defaultBackground()
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
