//
//  UITextField+Nexd.swift
//  Nexd
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UITextField {
    func styled(placeholder: String? = nil) {
        textColor = .black
        withBorder()
        attributedPlaceholder = placeholder?.asPlaceholder()
    }

    func withBorder(color: UIColor = .textFieldBorderColor) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        layer.cornerRadius = 8
    }
}
