//
//  TextField.swift
//  Nexd
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 41, bottom: 0, right: 27)

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rightViewSize = rightView?.bounds.size ?? .zero

        return CGRect(x: bounds.origin.x + padding.left,
                      y: bounds.origin.y + padding.top,
                      width: bounds.size.width - padding.left - padding.right - rightViewSize.width - 8,
                      height: bounds.size.height - padding.top - padding.bottom)
    }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let size = rightView?.bounds.size else { return .zero }

        return CGRect(x: bounds.maxX - size.width - padding.right,
                      y: (bounds.height / 2) - (size.height / 2),
                      width: size.width,
                      height: size.height)
    }

    func styled(placeholder: String? = nil, icon: UIImage? = nil) {
        font = R.font.proximaNovaSoftBold(size: 22.0)

        textColor = .black
        attributedPlaceholder = placeholder?.asPlaceholder()

        if let icon = icon {
            let imageView = UIImageView(image: icon.withRenderingMode(.alwaysTemplate))
            imageView.sizeToFit()
            rightViewMode = .always
            rightView = imageView
        }

        showNormal()
    }

    func showNormal() {
        rightView?.tintColor = .textFieldPlaceholderTextColor
        withBottomBorder()
    }

    func showError() {
        rightView?.tintColor = .errorTintColor
        withBottomBorder(color: .errorTintColor)
    }

    func showWarning() {
        rightView?.tintColor = .warningTintColor
        withBottomBorder(color: .warningTintColor)
    }

    func withBottomBorder(color: UIColor = .textFieldBorderColor) {
        let bottomLine = CALayer()
        /// Get information about screen width, without having to inject it (which may cause lifecycle issues).
        let screenWidth = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.frame.width
        let lineWidth = screenWidth != nil ? screenWidth! - 2 * Style.textFieldUnderliningHorizontalPadding : 0
        let bottomLineXPosition = Style.textFieldUnderliningHorizontalPadding - Style.standardLayoutMarginByApple
        bottomLine.frame = CGRect(x: bottomLineXPosition, y: 35, width: lineWidth, height: Style.textFieldUnderliningHeight)
        bottomLine.backgroundColor = R.color.textfieldStroke()?.cgColor
        borderStyle = UITextField.BorderStyle.none
        layer.addSublayer(bottomLine)
    }
}
