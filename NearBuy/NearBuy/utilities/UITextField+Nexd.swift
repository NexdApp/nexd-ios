//
//  UITextField+NearBuy.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UITextField {
    func styled(placeholder: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textFieldTextColor
        ]

        let attributedString = NSAttributedString(string: placeholder, attributes: attributes)

        attributedPlaceholder = attributedString

        layer.borderWidth = 1
        layer.borderColor = UIColor.textFieldBorderColor.cgColor
        layer.cornerRadius = 8
    }
}
