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
        /// Get information about screen width, without having to inject it (which may cause lifecycle issues).
        let screenWidth = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.frame.width
        let lineWidth = screenWidth != nil ? screenWidth! - 2 * Style.textFieldUnderliningHorizontalPadding : 0
        let bottomLineXPosition = Style.textFieldUnderliningHorizontalPadding - Style.standardLayoutMarginByApple
        bottomLine.frame = CGRect(x: bottomLineXPosition, y: 35, width: lineWidth, height: Style.textFieldUnderliningHeight)
        bottomLine.backgroundColor = R.color.textfieldStroke()?.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
