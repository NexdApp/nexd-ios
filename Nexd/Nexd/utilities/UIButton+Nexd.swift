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
        backgroundColor = .white
        layer.cornerRadius = 26

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.buttonTextColor,
            .font: UIFont.boldSystemFont(ofSize: 24)
        ]

        setAttributedTitle(NSAttributedString(string: text, attributes: attributes), for: .normal)

        addShadow()
    }

    func addShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3;
        layer.shadowRadius = 2;
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0);
    }
}
