//
//  UIColor+Nexd.swift
//  Nexd
//
//  Created by Tobias Schröpf on 22.03.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import UIKit

extension UIColor {
    static var gradientFrom: UIColor { UIColor(red: 108 / 255, green: 188 / 255, blue: 163 / 255, alpha: 1.0) }
    static var gradientTo: UIColor { UIColor(red: 21 / 255, green: 47 / 255, blue: 67 / 255, alpha: 1.0) }

    static var defaultBackgroundColor: UIColor { UIColor(red: 108 / 255, green: 188 / 255, blue: 153 / 255, alpha: 1.0) }

    static var textFieldPlaceholderTextColor: UIColor { UIColor(red: 204 / 255, green: 225 / 255, blue: 173 / 255, alpha: 1.0) }

    static var textFieldBorderColor: UIColor { UIColor(red: 204 / 255, green: 225 / 255, blue: 173 / 255, alpha: 1.0) }

    static var buttonTextColor: UIColor { UIColor(red: 112 / 255, green: 112 / 255, blue: 112 / 255, alpha: 1.0) }

    static var headingTextColor: UIColor { UIColor(red: 112 / 255, green: 112 / 255, blue: 112 / 255, alpha: 1.0) }

    static var titleTextColor: UIColor { UIColor(red: 112 / 255, green: 112 / 255, blue: 112 / 255, alpha: 1.0) }

    static var errorTintColor: UIColor { .red }

    static var warningTintColor: UIColor { .orange }

    static func from(hex: String) -> UIColor {
        guard hex.hasPrefix("#") else {
            return .clear
        }

        let red, green, blue, alpha: CGFloat

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])

        guard hexColor.count == 6 || hexColor.count == 8 else {
            return .clear
        }

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        guard scanner.scanHexInt64(&hexNumber) else {
            return .clear
        }

        red = CGFloat((hexNumber & 0xFF00_0000) >> 24) / 255
        green = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
        blue = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255

        let hasAlpha = hexColor.count == 8
        alpha = hasAlpha ? CGFloat(hexNumber & 0x0000_00FF) / 255 : 1.0

        return self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
