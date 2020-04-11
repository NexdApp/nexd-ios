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
        font = R.font.proximaNovaSoftBold(size: 22.0)

        textColor = .black
        withBottomBorder()
        attributedPlaceholder = placeholder?.asPlaceholder()
    }

    func withBottomBorder(color: UIColor = .textFieldBorderColor) {
        let bottomLine = CALayer()
        // TODO: Avoid hard coded values and calculate instead...  // swiftlint:disable:this todo
        let specifiedColor = UIColor(red: CGFloat(0/255.0), green: CGFloat(0/255.0), blue: CGFloat(0/255.0), alpha: CGFloat(0.2))
        bottomLine.frame = CGRect(x: 27.0, y: 35, width: 300, height: 1.0)
        bottomLine.backgroundColor = specifiedColor.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
