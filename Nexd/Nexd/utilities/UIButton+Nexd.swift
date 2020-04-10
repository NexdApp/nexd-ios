//
//  UIButton+Shadow.swift
//  Nexd
//
//  Created by Tobias Schröpf on 21.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UIButton {
    func style(text: String) {
        backgroundColor = UIColor.greenBackgroundColor
        layer.cornerRadius = 10

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.buttonTextColor,
            .font: R.font.proximaNovaSoftBold(size: 25)!
        ]

        setAttributedTitle(NSAttributedString(string: text, attributes: attributes), for: .normal)
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 41, bottom: 0, right: 0)

        addShadow()
    }

    func addShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }

    func addBorder(color: UIColor?) {
        guard let color = color else { return }
        layer.borderWidth = 2
        layer.borderColor = color.cgColor
        layer.cornerRadius = 10
    }
}
