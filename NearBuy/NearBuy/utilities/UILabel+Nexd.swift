//
//  UILabel+NearBuy.swift
//  NearBuy
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UILabel {
    func styleHeader(text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.buttonTextColor,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]

        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
