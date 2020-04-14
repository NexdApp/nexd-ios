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
        // TODO: Make CGRect size device dependent // swiftlint:disable:this todo
        bottomLine.frame = CGRect(x: 27.0, y: 35, width: 350, height: 1.0)
        bottomLine.backgroundColor = R.color.textfieldStroke()?.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
